class Client < TelegramWorkflow::Client
  def do_send_message(text:, parse_mode: '', chat_id: nil)
    if chat_id
      send_message(text: text, parse_mode: parse_mode)
    else
      send_message(text: text, parse_mode: parse_mode)
    end
  end

  def do_send_actions(text:, actions:, parse_mode: '')
    send_actions(text: text, actions: actions, parse_mode: parse_mode)
  end

  def do_send_document(filename:, content:)
    pp [:do_send_document, filename, content]
    send_document(document: TelegramWorkflow::InputFile.new(StringIO.new(content), filename: filename))
  end

  def send_actions(text:, actions:, parse_mode:)
    send_message(text: text, parse_mode: parse_mode, reply_markup: { inline_keyboard: actions })
  end

  def do_delete_message(chat_id:, message_id:)
    delete_message(chat_id: chat_id, message_id: message_id )
  end

  def do_edit_message(chat_id:, message_id:, text:, parse_mode: '', actions: [])
    edit_message_text(chat_id: chat_id, message_id: message_id, text: text, parse_mode: parse_mode, reply_markup: { inline_keyboard: actions })
  end
end
