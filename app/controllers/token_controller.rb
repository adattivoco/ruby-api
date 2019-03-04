class TokenController < ApplicationController
  before_action :authorize_company_request, only: :destroy
  before_action :authorize_admin_request, only: :destroy_admin

  # post /authenticate
  def create
    if user = User.authenticate(params[:email], params[:password])
      if (user._type == "Admin")
        render json: { user: {"_id" => user._id, auth_token: user.auth_token, name: user.name, email: user.email, admin: true} }
      else
        render json: { user: {"_id" => user._id, auth_token: user.auth_token, name: user.name, email: user.email, company_id: user.companies.first} }
      end
    else
      render json: { error: 'Invalid Credentials' }, status: :unauthorized
    end
  end

  # delete /invalidate
  def destroy
    render json: @current_user.logout
  end
end
