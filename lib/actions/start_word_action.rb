class Actions::StartWordAction < Actions::BaseAction
  attr_reader :result

  def initial
    @result = WordService.find_word(session[:user_authorize][params.user_id][:user])

    on_redirect do
      message = read_store_message(user_id: params.user_id)
      available_actions = [
        [{ text: "Знаю слово", callback_data: "yes" },
        { text: "Не знаю слово", callback_data: "no" }]
      ]

      res = client.do_edit_message(text: handle_word,
                                  chat_id: message[:chat_id],
                                  message_id: message[:message_id],
                                  actions: available_actions,
                                  parse_mode: "MarkdownV2")

      store_message(message_id: res.dig('result', 'message_id'),
                    chat_id: params.chat_id,
                    user_id: params.user_id,
                    text: res.dig('result', 'text'))
    end

    on_message do
      if params.callback_data == "yes"
        WordService.incorrect_attempts(@result[:object].id)
      elsif params.callback_data == "no"
        WordService.correct_attempts(@result[:object].id)
      end

      redirect_to Actions::StartWordAction
    end
  end

  private

  def handle_word
    if @result[:status]
      text
    else
      warning_text
      test
    end
  end

  def text
    <<-EOL
      Слово: *#{@result[:object].word.capitalize}*
      Транскрипция: `#{@result[:object].transcription.capitalize}`
      Перевод: ||#{@result[:object].translation.capitalize}||
    EOL
  end

  def warning_text
    <<-EOL
      Доступных слов не осталось
    EOL
  end

  def test
    redirect_to Actions::ListAction
  end
end
