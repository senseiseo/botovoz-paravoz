require "bundler/setup"
require "telegram_workflow"
require "date"
require './lib/app_config'
require 'pry'

require './models/user'
require './models/word'
require './models/user_word_relation'

module Actions
end

# dependencies = %w(
#   /home/isildur/botovoz/lib/actions/*.rb
#   /home/isildur/botovoz/lib/client.rb
# )
# dependencies.each do |path|
#   Dir[path].each { |path| require_relative path }
# end

dependencies = %w(
  actions/*.rb
  client.rb
  word_service.rb
  user_manager.rb
)

dependencies.each do |path|
  Dir[File.expand_path(File.join(__dir__, path))].each { |path| require_relative path }
end
