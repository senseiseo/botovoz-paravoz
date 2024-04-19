require 'erb'
require 'yaml'

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
    InitDb.establish_connection(config: config)
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
    config_data = Hashie::Mash.new(YAML.load((ERB.new(File.read(config_file))).result(binding)))
    @config = config_data
  end
end

