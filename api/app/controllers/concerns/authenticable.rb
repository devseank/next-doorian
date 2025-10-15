# app/controllers/concerns/authenticable.rb
module Authenticable
  extend ActiveSupport::Concern

  included do
    # You could move the before_action logic here too, but we'll 
    # keep it explicit in the controllers for clarity.
  end

  def authorize_request
    render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user ||= find_user_by_token
  end

  private

  def find_user_by_token
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      # 🔓 Decode and verify the token using your secret key
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
      User.find_by(id: decoded['user_id'])
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      # Handle various token errors (expired, bad signature, invalid format)
      nil
    end
  end
end