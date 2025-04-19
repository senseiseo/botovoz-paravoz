require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      Integer :uid, null: false
      String :nick_name
      Integer :count
      String :personal_chat_id
      String :publick_chat_id
      String :user_name
      String :last_name
    end
  end
end
