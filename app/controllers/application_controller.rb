class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :authenticate

  private

  attr_reader :current_user

  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      @current_user = User.find_by(auth_token: token)
    end
  end

  def render_not_found
    render json: { errors: "Record Not Found" }, status: :not_found
  end
end
