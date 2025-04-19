require 'sequel'

class Word < Sequel::Model(AppConfig.instance.db[:words])
  one_to_many :word_progress
  many_to_many :users, join_table: :word_progress
end