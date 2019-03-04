class User
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include ActiveModel::SecurePassword
  has_secure_password

  field :name,                   type: String
  field :email,                  type: String
  field :password_digest,        type: String
  field :auth_token,             type: String
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  field :sign_in_count,          type: Integer, default: 0
  field :last_sign_in_at,        type: Time

  validates_presence_of :name, :email

  index({reset_password_token: 1})
  index({auth_token: 1})
  index({email: 1})
  index({_type: 1})
  index({_type: 1, _id: 1})
  index({id: 1, auth_token: 1}, {unique: true})
  index({name: "text", email: "text", type: 1}, { name: "user_search" })

  before_save {self.email = email.downcase}

  # Methods

  def first_name
    if self.name.split.count > 1
      self.name.split[0..-2].join(' ')
    else
      self.name
    end
  end

  def last_name
    if self.name.split.count > 1
      self.name.split.last
    else
      ""
    end
  end

  def logout
    self.auth_token = nil
    self.save
  end


  # Class Methods

  def self.authenticate(email, password)
    begin
      user = find_by(email: email.downcase)
      if user && user.authenticate(password)
        user.sign_in_count = user.sign_in_count += 1
        user.last_sign_in_at = Time.now
        user.auth_token = JsonWebToken.encode({user_id: user._id})
        user.save!
      else
        user = nil
      end
    rescue => e
      logger.error "Error authenticating user: #{e.message}"
      user = nil
    end
    user
  end

  def self.authorize(user_id, auth_token)
    begin
      user = find_by(_id: user_id["$oid"], auth_token: auth_token)
    rescue => e
      logger.error "Error authorizing call: #{e.message}"
      user = nil
    end
    user
  end

end
