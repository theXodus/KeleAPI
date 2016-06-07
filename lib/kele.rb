require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
    @base_uri = 'https://www.bloc.io/api/v1'
    @user_info = { query: { email: email, password: password } }
  end

  def authorize
    user_hash = self.class.post("#{@base_uri}/sessions", @user_info)
    user_hash["auth_token"] ? user_hash["auth_token"] : user_hash
  end
end
