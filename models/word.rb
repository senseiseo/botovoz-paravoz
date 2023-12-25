require 'active_record'

class Word < ActiveRecord::Base
  has_many :user_word_relations
  has_many :users, through: :user_word_relations
end
