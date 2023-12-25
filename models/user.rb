require 'active_record'

class User < ActiveRecord::Base
  has_many :user_word_relations
  has_many :words, through: :user_word_relations
end
