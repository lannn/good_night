class User < ApplicationRecord
  has_secure_token :auth_token

  validates :name, presence: true
end
