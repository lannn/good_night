class SleepClock < ApplicationRecord
  belongs_to :user

  validates :bedtime, presence: true
  validate :wakeup_greater_than_bedtime

  private

  def wakeup_greater_than_bedtime
    if wakeup && wakeup < bedtime
      errors.add(:wakeup, "can't be less than bedtime")
    end
  end
end
