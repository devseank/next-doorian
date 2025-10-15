# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      expiration_time = Time.now.to_i + 24 * 3600 # 24 hours from now
      payload = { user_id: user.id, exp: expiration_time }
      # Encode using your secret key
      token = JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')

      render json: { 
        user: { 
          id: user.id, 
          username: user.username 
        }, 
        token: token 
      }, status: :ok
    else
      render json: { 
        error: "Invalid username or password" 
      }, status: :unauthorized
    end
  end

  def destroy
    # Logic for logout/token invalidation goes here. 
    # For now, we'll keep it simple.
    head :no_content
  end
end