class Actions::BaseActions < TelegramWorkflow::Action
  def shared
    return unless is_user_authorized?

    if params.message_text == "/cancel"
      redirect_to Actions::ListActions
    elsif params.message_text == "/start"
      redirect_to Actions::ListActions
    else
      super
    end
  end

  def is_user_authorized? = session.dig(:user_authorize, params.user_id) || user_authorization

  def user_authorization
    user = UserManager.find_or_create_user(params.user_id, params)
    if user.present?
      session[:user_authorize] ||= {}
      session[:user_authorize][params.user_id] ||= { user_id: params.user_id, user: user }
      pp session[:user_authorize][params.user_id]
    else
      client.do_send_message(text: "Пользователь не найден.", parse_mode: "Markdown")
      false
    end
  end
end
