class Actions::BaseAction < TelegramWorkflow::Action
  def shared
    return unless is_user_authorized?

    trim_messages

    if params.message_text == "/cancel" || params.message_text == "/start"
      redirect_to Actions::ListAction
    else
      super
    end

  rescue StandardError, NoMethodError => error
    handle_error(error)
  end

  def is_user_authorized? = session.dig(:user_authorize, params.user_id) || user_authorization

  def user_authorization
    user = UserManager.find_or_create_user(params.user_id, params)
    if user
      session[:user_authorize] ||= {}
      session[:user_authorize][params.user_id] ||= { user_id: params.user_id, user: user }
      pp session[:user_authorize][params.user_id]
    else
      client.do_send_message(text: "Пользователь не найден.", parse_mode: "Markdown")
      false
    end
  end

  def store_message(message_id:, chat_id:)
    session[:store_message] ||= []
    session[:store_message] << { message_id: message_id, chat_id: chat_id }
  end

  def trim_messages
    messages = session[:store_message]

    return unless messages

    if messages.length > 2
      messages_to_delete = messages[0..-3]
      messages_to_keep = messages[-2..-1]

      Concurrent::Future.execute do
        messages_to_delete.each do |message|
          client.do_delete_message(chat_id: message[:chat_id], message_id: message[:message_id])
        end
      end

      session[:store_message] = messages_to_keep
    end
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
