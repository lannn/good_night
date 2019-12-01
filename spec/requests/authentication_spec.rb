require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { authenticate_with_token(user.auth_token) }

  context "when the user has a valid token" do
    it "allows user to pass" do
      get "/sleep_clocks", headers: { "Authorization" => credentials }
      expect(response).to be_successful
    end
  end

  context "when the user has a invalid token" do
    it "returns access denied" do
      get "/sleep_clocks"
      expect(response).to be_unauthorized
      expect(response.body).to match(/access denied/i)
    end
  end
end
