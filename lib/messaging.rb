module Messaging
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
    message = { headers: { "authorization" => @auth_token}, body: { user_id: get_me["id"], recipient_id: get_me["current_enrollment"]["mentor_id"], subject: subject, "stripped-text" => text} }
    response = self.class.post("#{@base_uri}/messages", message)
    response.parsed_response
  end
end
