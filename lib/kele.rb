require 'json'
require 'httparty'

class Kele
  include HTTParty
  include JSON

  def initialize(email, password)
    @base_uri = 'https://www.bloc.io/api/v1'
    @user_info = { query: { email: email, password: password } }
    user_hash = self.class.post("#{@base_uri}/sessions", @user_info)
    @auth_token = user_hash["auth_token"]
  end

  def get_me
    response = self.class.get("#{@base_uri}/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.to_json)
  end
end
