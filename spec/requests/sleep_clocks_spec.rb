require "rails_helper"

RSpec.describe "SleepClocks API", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { authenticate_with_token(user.auth_token) }

  describe "GET /sleep_clocks" do
    let!(:sleep_clocks) { create_list(:sleep_clock, 10, user: user) }

    before do
      get "/sleep_clocks", headers: { "Authorization" => credentials }
    end

    it "returns sleep clocks" do
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(10)
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
      before do
        post "/sleep_clocks", params: valid_params, headers: { "Authorization" => credentials }
      end

      it "creates a sleep clock" do
        expect(response).to have_http_status(:created)
        expect(json["bedtime"]).to eq(valid_params[:bedtime].to_i)
        expect(json["wakeup"]).to eq(valid_params[:wakeup].to_i)
      end
    end

    context "when the request is invalid" do
      before do
        post "/sleep_clocks", headers: { "Authorization" => credentials }
      end

      it "returns a validation error" do
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
      before do
        put "/sleep_clocks/#{sleep_clock.id}", params: valid_params, headers: { "Authorization" => credentials }
      end

      it "returns the updated sleep clock" do
        expect(response).to have_http_status(:ok)
        expect(json["wakeup"]).to eq(valid_params[:wakeup].to_i)
      end
    end

    context "when the request is invalid" do
      before do
        put "/sleep_clocks/#{sleep_clock.id}",
            params: invalid_params,
            headers: { "Authorization" => credentials }
      end

      it "returns a validation error" do
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
