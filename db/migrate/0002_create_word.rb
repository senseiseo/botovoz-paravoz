require 'sequel'

Sequel.migration do
  change do
    create_table(:words) do
      primary_key :id
      String :word, null: false
      String :translation, null: false
      String :transcription, null: false
      DateTime :created_at
      DateTime :updated_at
      index :word, unique: true
    end
  end
end
