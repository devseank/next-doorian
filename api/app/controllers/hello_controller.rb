class HelloController < ApplicationController
  # Run the authorization check before the index action runs
  before_action :authorize_request

  def index
    render json: { message: "Welcome, #{current_user.username}! This is a secure resource." }
  end
end
