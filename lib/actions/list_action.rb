class Actions::ListAction < Actions::BaseAction
  def initial
    on_redirect do
      restart = flash[:restart]
      message = read_store_message(user_id: params.user_id)

      available_actions = [
        [{ text: "Начать изучение", callback_data: "start" }]
      ]

      if restart || message.blank?
        response = client.do_send_actions(text: "Начать изучение",
                                          actions: available_actions)
        store_message(message_id: response.dig('result', 'message_id'),
                      chat_id: params.chat_id,
                      user_id: params.user_id,
                      text: response.dig('result', 'text'))
      else
        res = client.do_edit_message(chat_id: message[:chat_id],
                                    message_id: message[:message_id],
                                    text: "Начать изучение",
                                    actions: available_actions)

        store_message(message_id: res.dig('result', 'message_id'),
                      chat_id: params.chat_id,
                      user_id: params.user_id,
                      text: res.dig('result', 'text'))
      end
    end

    on_message do
      next_action = if params.callback_data == "start"
        Actions::StartWordAction
      else
        client.do_send_message text: "❗️Incorrect action"
        :initial
      end

      redirect_to next_action
    end
  end
end
