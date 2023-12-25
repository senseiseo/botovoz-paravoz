class WordService
  class << self
    def app_config
      @app_config ||= AppConfig.new
    end

    def correct_attempts(word_id)
      user_word = UserWordRelation.find_by(word_id: word_id)
      user_word.correct_group += 1
      user_word.reviewed_at = DateTime.now
      user_word.hard_word = true if user_word.correct_group == 11
      user_word.save!
    end

    def incorrect_attempts(word_id)
      user_word = UserWordRelation.find_by(word_id: word_id)
      user_word.incorrect_group += 1
      user_word.reviewed_at = DateTime.now
      user_word.hard_word = true if user_word.incorrect_attempts == 10
      user_word.save!
    end

    def find_word(user)
      word = find_word_for_new_relations(user)
      user_word_relation = UserWordRelation.find_by(user_id: user.id, word_id: word[:object].id, hard_word: false)

      if word.present? && user_word_relation.time_to_next_appearance == 0
        { status: true, object: user_word_relation.word }
      else
        { status: false, object: "Доступных слов нет" }
      end
    end

    private

    def find_word_for_new_relations(user)
      random_word = Word.where.not(id: user.user_word_relations.pluck(:word_id))
                        .offset(rand(Word.count))
                        .limit(1)
                        .first

      if random_word.present?
        UserWordRelation.create(user: user, word: random_word)
        { status: true, object: random_word }
      else
        { status: false, object: "Нет доступных слов для создания связи" }
      end
    end
  end
end
