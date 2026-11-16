
class Api::V1::SessionsController < ApplicationController
  def create
    email = params[:email].to_s.strip.downcase

    user = User.where("LOWER(email) = ?", email).first

    unless user&.authenticate(params[:password])
      return render json: {
        error: "Invalid email or password"
      }, status: :unauthorized
    end

    result = Sessions::Issue.new(user: user).call

    render json: {
      token: result[:token],
      expires_at: result[:session].expires_at
    }, status: :created
  end
end
