class ApplicationController < ActionController::API
  include AuditLoggable

  # get /health
  def health
    render plain: 'ok'
  end

  protected

  def get_http_auth_header
    request.headers['Authorization'].present? ? request.headers['Authorization'].split(' ').last : nil
  end

  def authorize_company_request
    authorize_request(User)
  end

  def authorize_admin_request
    authorize_request(Admin)
  end

  def load_user
    if (undecoded_auth_header = get_http_auth_header)
      decoded_auth_token = JsonWebToken.decode(undecoded_auth_header)
      @current_user = User.authorize(decoded_auth_token[:user_id], undecoded_auth_header) if decoded_auth_token
    end
  end

  def authorize_request(user_class)
    if (undecoded_auth_header = get_http_auth_header)
      decoded_auth_token = JsonWebToken.decode(undecoded_auth_header)
      if decoded_auth_token
        @current_user = user_class.authorize(decoded_auth_token[:user_id], undecoded_auth_header)
        render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
      else
        user = User.find_by(auth_token: undecoded_auth_header)
        user.update_attributes(auth_token: nil) if user
        render json: { error: 'Invalid Token' }, status: :unauthorized
      end
    else
      render json: { error: 'Missing Token' }, status: :unauthorized
    end
  end

  def user_is_admin?
    @current_user._type == 'Admin'
  end
end
