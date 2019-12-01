FactoryBot.define do
  factory :sleep_clock do
    user
    bedtime { DateTime.current }
    wakeup { 8.hours.from_now }
  end
end
