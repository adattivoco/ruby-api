class UsersController < ApplicationController
  before_action :authorize_admin_request, except: [:send_reset, :attempt_reset, :update]
  before_action :authorize_company_request, only: [:update]

  # get /users
  def index
    if params[:admin] && params[:admin].downcase == "true"
      render json: Admin.all, except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
    elsif params[:admin] && params[:admin].downcase == "false"
      render json: CompanyUser.all, except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
    elsif params[:filter].blank?
      render json: User.all, except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
    else
      filter = params[:filter]
      filter = "\"#{filter}\"" if /@|./ =~ filter
      render json: CompanyUser.where({ "$text": { "$search": filter} } ).order(name: :asc), except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
    end
  end

  # get :id /users/:id
  def show
    render json: User.find(params[:id]), except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
  end

  # post /users/reset_password
  def send_reset
    user = User.find_by(email: params[:email])
    if user.present?
      token = SecureRandom.hex(24)
      user.set(reset_password_token: token, reset_password_sent_at: DateTime.now)
      UserMailer.reset_password(params[:email], token, params[:clientURL]).deliver
    end
  end

  # patch /users/reset_password
  def attempt_reset
    user = User.find_by(reset_password_token: params[:token])
    if user then (DateTime.now.utc - user.reset_password_sent_at)/3600 <= 8.0 ? token_valid = true : token_valid = false end
    if user.present? && token_valid
      user.password = params[:password]
      user.reset_password_token = nil
      user.reset_password_sent_at = nil
      user.save!
      auditLog(user, nil, :UPDATE_COMPANY_USER, "User: #{user.name}/#{user.email} password reset")
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  # post /users
  def create
      user = User.find_by(email: params[:email])
      if user.blank?
        admin = Admin.create( name: params['firstName'] + " " + params['lastName'],
                              email: params['email'],
                              password: SecureRandom.hex(8))
        token = SecureRandom.hex(24)
        admin.set(reset_password_token: token, reset_password_sent_at: DateTime.now)
        #UserMailer.reset_password(params[:email], token, params[:clientURL]).deliver
      end
      render json: user
  end

  # post /users/admin
  def create_admin
    user = User.find_by(email: params[:email])
    if user.blank?
      admin = Admin.create( name: params['name'],
                            email: params['email'],
                            password: SecureRandom.hex(8))
      token = SecureRandom.hex(24)
      admin.set(reset_password_token: token, reset_password_sent_at: DateTime.now)
      #UserMailer.reset_password(params[:email], token, params[:clientURL]).deliver
    end
    render json: Admin.all, except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
  end

  # patch or put /users/:id
  def update
    user = User.find(params[:id])
    if @current_user._id == user._id
      if params[:user][:current_password]
        if @current_user.authenticate(params[:user][:current_password])
          if params[:user][:password] == params[:user][:password_confirmation]
            @current_user.update!(params.require(:user).permit(:password))
            auditLog(@current_user, nil, :UPDATE_COMPANY_USER, "User: #{@current_user.name}/#{@current_user.email} password updated")
            render json: { user: @current_user, token: @current_user.auth_token }, methods: [:type, :firstName, :lastName]
          else
            render :json => {error: I18n.t(:passwords_dont_match)}, :status => :bad_request
          end
        else
          render :json => {error: I18n.t(:invalid_pw)}, :status => :bad_request
        end
      else

        if @current_user.name != params[:user][:name].to_s || @current_user.email != params[:user][:email].to_s.downcase
          oldName = @current_user.name
          oldEmail = @current_user.email
          @current_user.assign_attributes(params.require(:user).permit(:name, :email))
          if @current_user.valid?
            @current_user.save
            render json: { user: @current_user, token: @current_user.auth_token }, methods: [:type, :firstName, :lastName]
          else
            render :json => {error: "A user with that email already exists on our system. Please choose another email address."}, :status => :bad_request
          end
        else
          render json: { user: @current_user, token: @current_user.auth_token }, methods: [:type, :firstName, :lastName]
        end
      end
    else
      render :json => {error: I18n.t(:invalid_user)}, :status => :unauthorized
    end
  end

  # DELETE /users/:id
  def destroy
    if params[:admin] && params[:admin].downcase == "true"
      Admin.find(params[:id]).destroy
      render json: Admin.all, except: [:password_digest, :auth_token, :reset_password_token, :reset_password_sent_at], methods: [:type, :firstName, :lastName]
    end
  end
end
