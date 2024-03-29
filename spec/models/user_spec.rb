require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:sleep_clocks) }
  it { should validate_presence_of(:name) }
  it { should have_secure_token(:auth_token) }
end
