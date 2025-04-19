require 'sequel'
require 'pry'
require_relative 'lib/app_config'
require 'dotenv/load'
require 'sequel/extensions/migration'

namespace :db do
  desc 'Create the database'
  task :create do
    config = AppConfig.instance.config.database

    admin_db = Sequel.connect(
      adapter: 'postgres',
      host: config[:host],
      port: config[:port],
      user: config[:username],
      password: config[:password],
      max_connections: config[:max_connections]
    )

    database_name = config[:database]
    begin
      admin_db.execute("CREATE DATABASE #{database_name}")
      puts "Database #{database_name} created successfully."
    rescue Sequel::DatabaseError => e
      puts "Error creating database: #{e.message}"
    ensure
      admin_db.disconnect
    end
  end

  desc 'Drop the database'
  task :drop do
    config = AppConfig.instance.config.database
    admin_db = Sequel.connect(
      adapter: 'postgres',
      host: config[:host],
      port: config[:port],
      user: config[:username],
      password: config[:password],
      max_connections: config[:max_connections]
    )
    database_name = config[:database]
    begin
      admin_db.execute("DROP DATABASE IF EXISTS #{database_name}")
      puts "Database #{database_name} dropped successfully."
    rescue Sequel::DatabaseError => e
      puts "Error dropping database: #{e.message}"
    ensure
      admin_db.disconnect
    end
  end

  desc 'Migrate the database'
  task :migrate do
    db = AppConfig.instance.db
    Sequel::Migrator.run(db, 'db/migrate')
    puts "Database migrated successfully."
  end

  desc 'Rollback the last migration'
  task :rollback do
    db = AppConfig.instance.db
    Sequel::Migrator.run(db, 'db/migrate', target: Sequel::Migrator.latest_migration_version(db, 'db/migrate') - 1)
    puts "Last migration rolled back."
  end

  desc 'Seed the database'
  task :seed do
    db = AppConfig.instance.db
    seeds_file = File.join(__dir__, 'db', 'seeds.rb')
    if File.exist?(seeds_file)
      load seeds_file
      puts "Database seeded successfully."
    else
      puts "Seeds file not found at #{seeds_file}."
    end
  end
end
