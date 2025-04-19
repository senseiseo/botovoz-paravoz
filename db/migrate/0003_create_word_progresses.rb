require 'sequel'

Sequel.migration do
  change do
    create_table(:word_progresses) do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :word_id, :words
      DateTime :reviewed_at, default: Sequel.lit("'2000-01-01 00:00:00'")
      DateTime :next_appearance_at
      Integer :success_count, default: 0
      Integer :review_level, default: 0
      Integer :error_count, default: 0
      DateTime :level_updated_at, default: Sequel.lit("'2000-01-01 00:00:00'")
      TrueClass :is_difficult, default: false
      Integer :mistake_count, default: 0
      DateTime :created_at
      DateTime :updated_at

      index :next_appearance_at
      index [:user_id, :is_difficult]
    end
  end
end
