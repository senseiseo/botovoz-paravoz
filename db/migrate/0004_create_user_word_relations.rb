class CreateUserWordRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_word_relations do |t|
      t.belongs_to :user
      t.belongs_to :word
      t.datetime :reviewed_at, default: "2000-01-01 00:00:00"
      t.integer :correct_attempts, default: 0
      t.integer :correct_group, default: 0
      t.integer :incorrect_group, default: 0
      t.datetime :date_change_group, default: "2000-01-01 00:00:00"
      t.boolean :hard_word, default: false
      t.integer :incorrect_attempts, default: 0
      t.integer :time_wrong, default: 0

      t.timestamps
    end
  end
end
