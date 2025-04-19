require 'sequel'
require 'erb'
require 'yaml'
require 'hashie'
require 'pry'

class AppConfig
  include Singleton

  def initialize
    load_config
    setup_database
  end

  def env
    @env ||= ENV['APP_ENV'] || 'development'
  end

  def dev? = env == 'development'

  def production? = env == 'production'

  def test? = env == 'test'

  def setup_database
    @db = Sequel.connect(config.database)
  end

  def db
    @db
  end

  def group
    @group ||= 0
  end

  def max_level
    @max_level ||= 12
  end

  def config
    @config.fetch(env, @config.default)
  end

  private

  def load_config
    config_file = File.join(Dir.pwd, 'config', 'settings.yml')
    unless File.exist?(config_file)
      raise "Config file not found at #{config_file}"
    end
    erb_content = ERB.new(File.read(config_file)).result(binding)
    config_data = Hashie::Mash.new(YAML.load(erb_content, aliases: true))
    @config = config_data
  end
end
