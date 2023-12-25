class UserManager
  class << self
    def find_or_create_user(user_id, params)
      User.find_or_create_by(uid: user_id) do |user|
        user.user_name = params.user["first_name"]
        user.personal_chat_id = params.chat_id
        user.user_name = params.user["last_name"] || ''
        user.nick_name = params.user["username"] || ''
      end
    end
  end
end
