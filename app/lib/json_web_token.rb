class JsonWebToken
  class << self
    def encode(payload,
               exp = Time.now + Rails.configuration.token_expire_time,
               secret = Rails.application.secrets.secret_key_base)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret)
    end

    def decode(token,
               secret = Rails.application.secrets.secret_key_base,
               verify = true,
               opts = {})
      begin
        body = JWT.decode(token, secret, verify, opts)
        HashWithIndifferentAccess.new body[0]
      rescue
        nil
      end
    end
  end
end
