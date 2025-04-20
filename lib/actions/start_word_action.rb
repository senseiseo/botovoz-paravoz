class Actions::StartWordAction < Actions::BaseAction
  attr_reader :result

  def initial
    if session[:word_batch].nil? || session[:word_batch].empty?
      fetch_new_word_batch
    end

    @result = get_next_word_from_batch

    on_redirect do
      available_actions = [
        [{ text: "Знаю слово", callback_data: "yes" },
         { text: "Не знаю слово", callback_data: "no" }]
      ]
      client.do_send_message(text: handle_word, parse_mode: "MarkdownV2")
      client.do_send_actions(text: "Выберите действие:", actions: available_actions)
    end

    on_message do
      if params.callback_data == "yes"
        WordService.success_count(@result[:object].id, session[:user_authorize][params.user_id][:user].id)
      elsif params.callback_data == "no"
        WordService.mistake_count(@result[:object].id, session[:user_authorize][params.user_id][:user].id)
      end

      redirect_to Actions::StartWordAction
    end
  end

  private

  def fetch_new_word_batch
    user = session[:user_authorize][params.user_id][:user]
    batch_result = WordService.find_word_batch(user, 20)

    if batch_result[:status]
      session[:word_batch] = batch_result[:object].map do |word|
        { word: word, used: false }
      end
    else
      session[:word_batch] = []
    end
  end

  def get_next_word_from_batch
    unused_word = session[:word_batch].find { |w| !w[:used] }

    if unused_word
      unused_word[:used] = true
      { status: true, object: unused_word[:word] }
    else
      fetch_new_word_batch

      if session[:word_batch].any?
        get_next_word_from_batch
      else
        { status: false, object: "Доступных слов нет" }
      end
    end
  end

  def handle_word
    if @result[:status]
      text
    else
      warning_text
    end
  end

  def text
    <<~EOL
      Слово: *#{@result[:object].word.capitalize}*
      Транскрипция: `#{@result[:object].transcription.capitalize}`
      Перевод: ||#{@result[:object].translation.capitalize}||
    EOL
  end

  def warning_text
    <<~EOL
      Доступных слов не осталось
    EOL
  end
end