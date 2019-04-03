class TokenController < ApplicationController
  before_action :authorize_company_request, only: :destroy
  before_action :authorize_admin_request, only: :destroy_admin

  # post /auth
  def create
    pp
    if user = User.authenticate(params[:email], params[:password])
      render json: { user: user, token: user.auth_token }, methods: [:type, :firstName, :lastName]
    else
      render json: { error: 'Invalid Credentials' }, status: :unauthorized
    end
  end

  # delete /auth
  def destroy
    render json: @current_user.logout
  end
end
