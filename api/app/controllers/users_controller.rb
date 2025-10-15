# api/app/controllers/users_controller.rb

class UsersController < ApplicationController
  # POST /signup (Maps to users#create)
  def create
    # Use User.create! to raise an error if validation fails
    user = User.create!(user_params)

    # If creation is successful, issue a token and return the user data
    token = user.encode_token
    render json: { user: user_data_response(user), token: token }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  # Strong parameters for user creation (signup)
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation) 
  end

  # Helper method to define what user data is sent back to the client
  def user_data_response(user)
    # Never send the 'password_digest' back
    { id: user.id, username: user.username }
  end
end