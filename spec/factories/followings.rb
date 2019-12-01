FactoryBot.define do
  factory :following do
    user
    association :follower, factory: :user
  end
end
