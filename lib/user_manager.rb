require 'sequel'

class UserManager
  class << self
    def find_or_create_user(user_id, params)
      user = User.where(uid: user_id).first
      unless user
        user = User.create(
          uid: user_id,
          user_name: params.user["first_name"],
          personal_chat_id: params.chat_id,
          last_name: params.user["last_name"] || '',
          nick_name: params.user["username"] || ''
        )
      end
      user
    end
  end
end
