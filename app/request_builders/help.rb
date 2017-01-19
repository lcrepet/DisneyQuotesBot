module Clarke::RequestsBuilder::Help
  class << self
    def valid?(_)
      true
    end

    def build_requests(event)
      Clarke::ActionRequest.new('send_help', event)
    end
  end
end
