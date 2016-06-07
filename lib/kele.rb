require 'httparty'

class Kele
  include HTTParty


  def initialize(email, password)
    @base_uri = 'https://www.bloc.io/api/v1'
    @userInfo = {email: email, password: password}
  end

  def auth
    @auth = self.class.post("#{@base_uri}/sessions", @userInfo)
    puts @auth.inspect
  end
end
