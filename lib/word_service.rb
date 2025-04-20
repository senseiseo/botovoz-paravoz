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
        .where(Sequel.lit('next_appearance_at <= ?', Time.now))
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

    def find_word_batch(user, count = 20)
      review_words = WordProgres
        .where(user_id: user.id, is_difficult: false)
        .where(Sequel.lit('next_appearance_at <= ?', Time.now))
        .order(Sequel.asc(:next_appearance_at))
        .limit(count)
        .all
        .map { |wp| wp.word }

      if review_words.length >= count
        return { status: true, object: review_words.uniq.take(count) }
      end

      remaining_count = count - review_words.length
      new_words_result = find_words_for_new_relations(user, remaining_count)

      if new_words_result[:status]
        all_words = review_words + new_words_result[:object]
        { status: true, object: all_words.uniq }
      else
        if review_words.any?
          { status: true, object: review_words.uniq }
        else
          { status: false, object: "Доступных слов нет" }
        end
      end
    end

    private

    def find_words_for_new_relations(user, count = 20)
      used_word_ids = WordProgres.where(user_id: user.id).select(:word_id)

      available_words = Word.exclude(id: used_word_ids).all

      if available_words.any?
        random_words = available_words.shuffle.take(count)

        random_words.each do |word|
          WordProgres.create(
            user_id: user.id,
            word_id: word.id,
            reviewed_at: Time.now,
            next_appearance_at: Time.now
          )
        end

        { status: true, object: random_words }
      else
        { status: false, object: "Нет доступных слов для создания связи" }
      end
    end
  end
end
