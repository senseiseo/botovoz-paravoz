require 'sequel'

class User < Sequel::Model(AppConfig.instance.db[:users])
  one_to_many :word_progress
  many_to_many :words, join_table: :word_progress
end
