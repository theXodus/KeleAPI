require 'json'
require 'httparty'
require 'table_print'
require 'roadmap'
require 'messaging'

class Kele
  include HTTParty
  include JSON
  include Roadmap
  include Messaging

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

  def create_submission(checkpoint_id, assignment_branch = nil, assignment_commit_link = nil, comment = nil)
    submission = { headers: { "authorization" => @auth_token}, body: { checkpoint_id: checkpoint_id,
                                                                       assignment_branch: assignment_branch,
                                                                       assignment_commit_link: assignment_commit_link,
                                                                       comment: comment,
                                                                       enrollment_id: get_me["current_enrollment"]["id"]
                                                                       }}
   response = self.class.post("#{@base_uri}/checkpoint_submissions", submission)
 end
end
