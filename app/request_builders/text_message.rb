module Clarke::RequestsBuilder::TextMessage
  class << self
    def valid?(event)
      event.is_a?(Clarke::Messenger::Events::TextMessage) && event.text
    end

    def build_requests(event)
      user = User.find_or_create_by(messenger_id: event.sender)
      actions = []
      actions << Clarke::ActionRequest.new('welcome', event) if user.sessions.empty?

      scenario = start_or_find_scenario(user)
      scenario.make_sense_of(event.action)

      actions << Clarke::ActionRequest.new('quiz', event, scenario.parameters)
    end

    def start_or_find_scenario(user)
      scenario = user.current_scenario
      return scenario if scenario

      Quiz.create(session: user.current_or_create_session)
    end
  end
end
