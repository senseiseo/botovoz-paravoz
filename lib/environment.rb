require 'bundler/setup'
if ENV['APP_ENV'] == 'development'
  require 'dotenv/load'
end
require 'telegram_workflow'
require 'date'
require './lib/app_config'
require 'i18n'
require 'concurrent-ruby'
require 'pry'

require './models/user'
require './models/word'
require './models/user_word_relation'

module Actions
end

dependencies = %w(
  actions/*.rb
  client.rb
  word_service.rb
  user_manager.rb
)

dependencies.each do |path|
  Dir[File.expand_path(File.join(__dir__, path))].each { |path| require_relative path }
end

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
