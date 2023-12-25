require 'rubygems'
require 'bundler/setup'
require 'pry'

require 'sqlite3'
require 'active_record'
require 'yaml'

namespace :db do
  desc 'Create the database'
  task :create do
    connection_details = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Tasks::DatabaseTasks.create
  end

  desc 'Migrate the database'
  task :migrate do
    connection_details = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end

  desc 'Seed the database'
  task :seed do
    connection_details = YAML.load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    seeds_file = File.join(__dir__, 'db', 'seeds.rb')
    load seeds_file
  end
end

# It's also possible to use all ActiveRecord tasks with postgresql if necessary
# require 'rubygems'
# require 'bundler/setup'

# require 'pg'
# require 'active_record'
# require 'yaml'
# require 'csv'

# require_relative 'lib/init_db'

# task :environment do
#   RAKE_PATH = File.expand_path('.')
#   RAKE_ENV  = ENV.fetch('APP_ENV', 'development')
#   ENV['RAILS_ENV'] = RAKE_ENV

#   Bundler.require :default, RAKE_ENV

#   ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
#   ActiveRecord::Tasks::DatabaseTasks.root             = RAKE_PATH
#   ActiveRecord::Tasks::DatabaseTasks.env              = RAKE_ENV
#   ActiveRecord::Tasks::DatabaseTasks.db_dir           = 'db'
#   ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ['db/migrate']
#   ActiveRecord::Tasks::DatabaseTasks.seed_loader      = OpenStruct.new(load_seed: nil)
# end

# # Use Rails 6 migrations
# load 'active_record/railties/databases.rake'
