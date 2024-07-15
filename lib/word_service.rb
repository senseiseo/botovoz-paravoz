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
      user_word.next_review_time = DateTime.now + user_word.time_to_next_review
      user_word.save!
    end

    def incorrect_attempts(word_id)
      user_word = UserWordRelation.find_by(word_id: word_id)
      user_word.incorrect_group += 1
      user_word.reviewed_at = DateTime.now
      user_word.hard_word = true if user_word.incorrect_attempts == 10
      user_word.next_review_time = DateTime.now + 1.minute
      user_word.save!
    end

    def find_word(user)
      user_word_relation = find_due_word(user)
      if user_word_relation
        { status: true, object: user_word_relation.word }
      else
        word = find_word_for_new_relations(user)
        if word[:status]
          { status: true, object: word[:object] }
        else
          { status: false, object: "Доступных слов нет" }
        end
      end
    end

    private

    def find_due_word(user)
      UserWordRelation.where(user_id: user.id, hard_word: false)
                      .where("next_review_time <= ?", DateTime.now)
                      .order("RANDOM()")
                      .first
    end

    def find_word_for_new_relations(user)
      random_word = Word.where.not(id: user.user_word_relations.pluck(:word_id))
                        .or(Word.where.not(id: UserWordRelation.where(user_id: user.id).where.not(next_review_time: nil).pluck(:word_id)))
                        .order("RANDOM()")
                        .limit(1)
                        .first

      if random_word.present?
        UserWordRelation.create(user: user, word: random_word, next_review_time: nil)
        { status: true, object: random_word }
      else
        { status: false, object: "Нет доступных слов для создания связи" }
      end
    end
  end
end
