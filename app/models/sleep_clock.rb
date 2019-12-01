class SleepClock < ApplicationRecord
  belongs_to :user

  validates :bedtime, presence: true
  validate :wakeup_greater_than_bedtime

  scope :in_past_week, -> { where("bedtime >= ?", 1.week.ago.beginning_of_week).where("wakeup <= ?", 1.week.ago.end_of_week) }
  scope :ordered_by_sleep_length_desc, -> { order(Arel.sql("(wakeup - bedtime) DESC")) }

  private

  def wakeup_greater_than_bedtime
    if wakeup && wakeup < bedtime
      errors.add(:wakeup, "can't be less than bedtime")
    end
  end
end
