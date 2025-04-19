#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv/load' if ENV['APP_ENV'] == 'development'
require 'telegram_workflow'
require 'date'
require 'i18n'
require 'concurrent-ruby'
require 'pry'
require 'hashie'

require_relative 'app_config'
require_relative 'client'
require_relative 'word_service'
require_relative 'user_manager'

require './models/user'
require './models/word'
require './models/word_progres'

module Actions
end

Dir[File.expand_path('actions/*.rb', __dir__)].each { |path| require path }

I18n.load_path << Dir[File.expand_path('config/locales/*.yml')]

AppConfig.instance

TelegramWorkflow.configure do |config|
  config.start_action = Actions::Start
  config.session_store = TelegramWorkflow::Stores::InMemory.new
  config.client = Client
  config.api_token = AppConfig.instance.config.telegram.token
end

trap "SIGINT" do
  puts "Exiting..."
  TelegramWorkflow.stop_updates
end

pool_options = {
  max_threads: AppConfig.instance.config.concurrent_ruby.max_threads.to_i,
  min_threads: AppConfig.instance.config.concurrent_ruby.min_threads.to_i,
  auto_terminate: AppConfig.instance.config.concurrent_ruby.auto_terminate,
  idletime: AppConfig.instance.config.concurrent_ruby.idletime.to_i,
  max_queue: AppConfig.instance.config.concurrent_ruby.max_queue.to_i
}

pool = Concurrent::ThreadPoolExecutor.new(pool_options)

TelegramWorkflow.updates(timeout: AppConfig.instance.config.timeout.to_i).each do |params|
  pool.post do
    begin
      TelegramWorkflow.process(params)
    rescue StandardError => error
      TelegramWorkflow.config.logger.info(error.message)
    end
  end
end

pool.shutdown
pool.wait_for_termination
