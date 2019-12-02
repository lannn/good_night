require "rails_helper"

RSpec.describe "SleepClocks API", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { authenticate_with_token(user.auth_token) }

  describe "GET /sleep_clocks" do
    let!(:sleep_clocks) { create_list(:sleep_clock, 10, user: user) }

    it "returns sleep clocks ordered by created time desc" do
      get "/sleep_clocks", headers: { "Authorization" => credentials }
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(10)
      expect(json.first["id"]).to eq(sleep_clocks.last.id)
      expect(json.last["id"]).to eq(sleep_clocks.first.id)
    end
  end

  describe "GET /sleep_clocks/friends" do
    let(:following) { create(:following, user: user) }
    let!(:beginning_of_past_week) { 1.week.ago.beginning_of_week }
    let!(:end_of_past_week) { 1.week.ago.end_of_week }
    let!(:invalid_sleep_clock_1) { create(:sleep_clock, user: following.follower, bedtime: beginning_of_past_week - 1.hours, wakeup: beginning_of_past_week + 7.hours) }
    let!(:sleep_clock_1) { create(:sleep_clock, user: following.follower, bedtime: beginning_of_past_week + 23.hours, wakeup: beginning_of_past_week + 31.hours) }
    let!(:sleep_clock_2) { create(:sleep_clock, user: following.follower, bedtime: beginning_of_past_week + 1.day + 23.hours, wakeup: beginning_of_past_week + 1.day + 32.hours) }
    let!(:sleep_clock_3) { create(:sleep_clock, user: following.follower, bedtime: end_of_past_week - 1.hours, wakeup: end_of_past_week + 7.hours) }
    let!(:user_sleep_clock) { create(:sleep_clock, user: user, bedtime: beginning_of_past_week + 23.hours, wakeup: beginning_of_past_week + 31.hours) }

    it "returns sleep clocks over the past week for their friends and ordered by the length of their sleep desc" do
      get "/sleep_clocks/friends", headers: { "Authorization" => credentials }
      sleep_clock_ids = json.map { |e| e["id"] }
      expect(sleep_clock_ids.size).to eq(3)
      expect(sleep_clock_ids).to include(sleep_clock_1.id, sleep_clock_2.id, sleep_clock_3.id)
      expect(sleep_clock_ids.first).to eq(sleep_clock_2.id)
      expect(sleep_clock_ids.second).to eq(sleep_clock_3.id)
      expect(sleep_clock_ids.last).to eq(sleep_clock_1.id)
    end
  end

  describe "GET /sleep_clocks/:id" do
    let(:sleep_clock) { create(:sleep_clock) }

    context "when the sleep clock is found" do
      it "returns a sleep clock" do
        get "/sleep_clocks/#{sleep_clock.id}", headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:ok)
        expect(json["id"]).to eq(sleep_clock.id)
        expect(json["bedtime"]).to eq(sleep_clock.bedtime.to_i)
        expect(json["wakeup"]).to eq(sleep_clock.wakeup.to_i)
      end
    end

    context "when the sleep clock is not found" do
      it "returns not found" do
        get "/sleep_clocks/-1", headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:not_found)
        expect(json["errors"]).to include("Record Not Found")
      end
    end
  end

  describe "POST /sleep_clocks" do
    let(:valid_params) { { bedtime: DateTime.current, wakeup: 8.hours.from_now } }

    context "when the request is valid" do
      it "creates a sleep clock" do
        post "/sleep_clocks", params: valid_params, headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:created)
        expect(json["bedtime"]).to eq(valid_params[:bedtime].to_i)
        expect(json["wakeup"]).to eq(valid_params[:wakeup].to_i)
      end
    end

    context "when the request is invalid" do
      it "returns a validation error" do
        post "/sleep_clocks", headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Bedtime can't be blank")
      end
    end
  end

  describe "PUT /sleep_clocks/:id" do
    let(:sleep_clock) { create(:sleep_clock) }
    let(:valid_params) { { wakeup: sleep_clock.bedtime + 9.hours } }
    let(:invalid_params) { { wakeup: sleep_clock.bedtime - 9.hours } }

    context "when the request is valid" do
      it "returns the updated sleep clock" do
        put "/sleep_clocks/#{sleep_clock.id}", params: valid_params, headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:ok)
        expect(json["wakeup"]).to eq(valid_params[:wakeup].to_i)
      end
    end

    context "when the request is invalid" do
      it "returns a validation error" do
        put "/sleep_clocks/#{sleep_clock.id}", params: invalid_params, headers: { "Authorization" => credentials }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Wakeup can't be less than bedtime")
      end
    end
  end

  describe "DELETE /sleep_clocks/:id" do
    let(:sleep_clock) { create(:sleep_clock) }

    it "returns no content" do
      delete "/sleep_clocks/#{sleep_clock.id}", headers: { "Authorization" => credentials }
      expect(response).to have_http_status(:no_content)
    end
  end
end
