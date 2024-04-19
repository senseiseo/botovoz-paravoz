# frozen_string_literal: true

require 'active_record'

class InitDb
  class << self
    def establish_connection(config:)
      ActiveRecord::Base.establish_connection(config.database)
    end
  end
end
