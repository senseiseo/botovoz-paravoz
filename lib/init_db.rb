# frozen_string_literal: true

require 'active_record'

class InitDb
  class << self
    def establish_connection
      configuration = AppConfig.instance.config.database

      ActiveRecord::Base.establish_connection(configuration)
    end
  end
end
