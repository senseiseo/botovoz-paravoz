# frozen_string_literal: true

require 'yaml'
require './lib/init_db'

class AppConfig
  def initialize
    setup_database
  end

  def token
    @token ||= YAML.load(IO.read('config/secrets.yml'))['telegram_bot_token']
  end

  def setup_database
    InitDb.establish_connection
  end

  def group
    @group ||= 0
  end

  def max_level
    @max_level ||= 12
  end
end
