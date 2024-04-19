class Client < TelegramWorkflow::Client
  def do_send_message(text:, parse_mode: '')
    send_message(text: text, parse_mode: parse_mode)
  end

  def do_send_actions(text:, actions:)
    send_actions(text: text, actions: actions)
  end

  def send_actions(text:, actions:)
    send_message(text: text, reply_markup: { inline_keyboard: actions })
  end

  def do_delete_message(chat_id:, message_id:)
    delete_message(chat_id: chat_id, message_id: message_id )
  end
end
