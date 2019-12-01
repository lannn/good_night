class Following < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: "User"

  validates :user, presence: true
  validates :follower, presence: true
  validates :user_id, uniqueness: { scope: :follower_id }
end
