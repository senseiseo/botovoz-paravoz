class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :uid, null: false
      t.string :nick_name
      t.integer :count
      t.string :personal_chat_id
      t.string :publick_chat_id
      t.string :user_name
      t.string :last_name
    end
  end
end
