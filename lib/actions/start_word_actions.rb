class Actions::StartWordActions < Actions::BaseActions
  attr_reader :result

  def initial
    @result = WordService.find_word(session[:user_authorize][params.user_id][:user])

    on_redirect do
      available_actions = [
        [{ text: "Знаю слово", callback_data: "yes" },
        { text: "Не знаю слово", callback_data: "no" }]
      ]

      client.send_message(
        text: handle_word,
        parse_mode: "MarkdownV2"
      )
      client.send_actions "Выберите действие:", available_actions
    end

    on_message do
      if params.callback_data == "yes"
        WordService.incorrect_attempts(@result[:object].id)
      elsif params.callback_data == "no"
        WordService.correct_attempts(@result[:object].id)
      end

      redirect_to Actions::StartWordActions
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
    redirect_to Actions::ListActions
  end
end
