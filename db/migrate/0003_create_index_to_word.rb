class CreateIndexToWord < ActiveRecord::Migration[6.0]
  def change
    add_index :words, :word, unique: true
    add_index :words, :correct_group
  end
end
