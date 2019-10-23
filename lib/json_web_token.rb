# require 'jwt'
class JsonWebToken
  SECRET_KEY = "cced5dc34a8b10b3914228972f2b929e8f91fa6151ff09b6ea4e3b0655c4447e008e37008ea043e51ce4e029d0fc0138ce2b36007f319e5ca1cb45efeda98369"#Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
