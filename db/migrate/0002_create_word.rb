class CreateWord < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :word, null: false
      t.string :translation, null: false
      t.string :transcription, null: false

      t.timestamps
    end
  end
end
