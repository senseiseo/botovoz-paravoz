class Actions::BaseAction < TelegramWorkflow::Action
  def shared
    return unless is_user_authorized?

    if params.message_text == "/cancel" || params.message_text == "/start"
      redirect_to Actions::ListAction, restart: true
    else
      super
    end

  rescue StandardError, NoMethodError => error
    handle_error(error)
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

  def store_message(message_id:, chat_id:, user_id:, text:, overwrite_last: false)
    session[:store_message] ||= {}
    session[:store_message][user_id] ||= []

    if overwrite_last && session[:store_message][user_id].length >= 2
      session[:store_message][user_id][-2] = { message_id: message_id, chat_id: chat_id, text: text }
    else
      session[:store_message][user_id] << { message_id: message_id, chat_id: chat_id, text: text  }
    end
  end

  def read_store_message(user_id:)
    data = session.dig(:store_message, user_id)
    return [] unless data

    data.last
  end

  private

  def handle_error(error)
    logger.info "Произошла ошибка: #{error.message}"

    redirect_to Actions::ListAction
  end

  def logger
    @logger ||= TelegramWorkflow.config.logger
  end
end
