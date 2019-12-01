class User < ApplicationRecord
  has_secure_token :auth_token
  has_many :sleep_clocks

  validates :name, presence: true
end
