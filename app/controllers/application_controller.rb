class ApplicationController < ActionController::API
  private

  def current_user
    return @current_user if defined?(@current_user)

    header = request.headers["Authorization"].to_s

    scheme, token = header.split(" ", 2)

    unless scheme&.casecmp?("Bearer") && token.present?
      return @current_user = nil
    end

    @current_user = Sessions::Authenticate.new(
      token: token
    ).call
  end

  def authenticate_user!
    return if current_user

    render json: [
      error: "Authentication required"
    ], status: :unauthorized
  end
end
