class User < ApplicationRecord
  has_secure_token :auth_token
  has_many :sleep_clocks
  has_many :followings
  has_many :followers, through: :followings

  validates :name, presence: true
end
