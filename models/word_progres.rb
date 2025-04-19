require 'sequel'

class WordProgres < Sequel::Model(AppConfig.instance.db[:word_progresses])
  many_to_one :user
  many_to_one :word

  def time_to_next_appearance
    if reviewed_at && next_appearance_at
      difference = next_appearance_at - Time.now
      [difference, 0].max
    else
      10 * 365 * 24 * 60 * 60
    end
  end

  def time_to_next_review
    group_times = {
      0 => 0,
      1 => 5,
      2 => 25,
      3 => 2 * 60,
      4 => 10 * 60,
      5 => 1 * 60 * 60,
      6 => 5 * 60 * 60,
      7 => 1 * 24 * 60 * 60,
      8 => 5 * 24 * 60 * 60,
      9 => 25 * 24 * 60 * 60,
      10 => 4 * 30 * 24 * 60 * 60
    }
    group_times.default = 10 * 365 * 24 * 60 * 60
    group_times[review_level || 0]
  end
end
