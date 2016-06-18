require 'json'
require 'httparty'
require 'table_print'
require 'roadmap'

class Kele
  include HTTParty
  include JSON
  include Roadmap

  def initialize(email, password)
    @base_uri = 'https://www.bloc.io/api/v1'
    @user_info = { query: { email: email, password: password } }
    user_hash = self.class.post("#{@base_uri}/sessions", @user_info)
    @auth_token = user_hash["auth_token"]
  end

  def get_me
    response = self.class.get("#{@base_uri}/users/me", headers: { "authorization" => @auth_token })
    response.parsed_response
  end

  def get_mentor_availability(id)
    response = self.class.get("#{@base_uri}/mentors/#{id}/student_availability", headers: { "authorization" => @auth_token })
    tp response.parsed_response # tp calls table_print
  end

  def get_messages(page = nil)
    response = self.class.get("#{@base_uri}/message_threads", headers: { "authorization" => @auth_token })
    body = response.parsed_response
    if page
      self.class.get("#{@base_uri}/message_threads", { headers: { "authorization" => @auth_token }, body: { page: page }})
    else
      all_threads = (1..(response["count"]/10 + 1)).map do |p|
        self.class.get("#{@base_uri}/message_threads", { headers: { "authorization" => @auth_token }, body: { page: p }})
      end
    end
  end

  def create_message(subject, text)
    message = { headers: { "authorization" => @auth_token}, body: { user_id: get_me['id'], recipient_id: get_me["current_enrollment"]["mentor_id"], subject: subject, "stripped-text" => text} }
    response = self.class.post("#{@base_uri}/messages", message)
    response.parsed_response
  end
end
