require 'active_record'

class UserWordRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :word

  def time_to_next_appearance
    if reviewed_at.present?
      difference = time_to_next_review.ago - reviewed_at
      -[difference, 0].min
    else
      10.years
    end
  end

  def time_to_next_review
    group_times = {
      0 => 0.seconds,
      1 => 5.seconds,
      2 => 25.seconds,
      3 => 2.minutes,
      4 => 10.minutes,
      5 => 1.hour,
      6 => 5.hours,
      7 => 1.day,
      8 => 5.days,
      9 => 25.days,
      10 => 4.months
    }

    group_times.default = 10.years

    group_times[correct_group]
  end
end
