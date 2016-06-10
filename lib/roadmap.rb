module Roadmap
  def get_roadmap(id)
    response = self.class.get("#{@base_uri}/roadmaps/#{id}", headers: { "authorization" => @auth_token })
    response.parsed_response
  end

  def get_checkpoint(id)
    response = self.class.get("#{@base_uri}/checkpoints/#{id}", headers: { "authorization" => @auth_token })
    response.parsed_response
  end
end
