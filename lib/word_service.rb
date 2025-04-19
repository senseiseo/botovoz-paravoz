require 'sequel'

class WordService
  class << self
    def app_config
      @app_config ||= AppConfig.instance
    end

    def success_count(word_id, user_id)
      user_word = WordProgres.where(word_id: word_id, user_id: user_id).first

      user_word.update(
        review_level: user_word.review_level + 1,
        success_count: user_word.success_count + 1,
        reviewed_at: Time.now,
        next_appearance_at: Time.now + user_word.time_to_next_review,
        is_difficult: user_word.review_level >= 10
      )
    end

    def mistake_count(word_id, user_id)
      user_word = WordProgres.where(word_id: word_id, user_id: user_id).first

      user_word.update(
        error_count: user_word.error_count + 1,
        mistake_count: user_word.mistake_count + 1,
        reviewed_at: Time.now,
        next_appearance_at: Time.now,
        is_difficult: user_word.mistake_count >= 9
      )
    end

    def find_word(user)
      user_word_relation = WordProgres
        .where(user_id: user.id, is_difficult: false)
        .where { next_appearance_at <= Time.now }
        .order(Sequel.asc(:next_appearance_at))
        .first

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

    def find_word_for_new_relations(user)
      used_word_ids = WordProgres.where(user_id: user.id).select(:word_id)
      random_word = Word.where { id !~ used_word_ids }.order(Sequel.lit('RANDOM()')).first

      if random_word
        user_word = WordProgres.create(
          user_id: user.id,
          word_id: random_word.id,
          reviewed_at: Time.now,
          next_appearance_at: Time.now
        )
        { status: true, object: random_word }
      else
        { status: false, object: "Нет доступных слов для создания связи" }
      end
    end
  end
end
