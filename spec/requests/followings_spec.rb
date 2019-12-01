require "rails_helper"

RSpec.describe "Followings API", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { authenticate_with_token(user.auth_token) }
  let(:follower) { create(:user) }

  describe "POST /followings" do
    context "when the follower exists" do
      it "creates a following" do
        post "/followings",
             params: { follower_id: follower.id },
             headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:created)
        expect(json["follower_id"]).to eq(follower.id)
        expect(json["user_id"]).to eq(user.id)
      end
    end

    context "when the follower does not exist" do
      it "returns a validation error" do
        post "/followings", headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Follower must exist")
      end
    end
  end

  describe "DELETE /followings/:id" do
    let!(:following) { create(:following, user: user, follower: follower) }

    it "returns no content" do
      delete "/followings/#{following.id}", headers: { "Authorization" => credentials }
      expect(response).to have_http_status(:no_content)
    end
  end
end
