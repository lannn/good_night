require 'rails_helper'

RSpec.describe Following, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:follower) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:follower) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:follower_id) }
end
