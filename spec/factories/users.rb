FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    auth_token { SecureRandom.base58(24) }
  end
end
