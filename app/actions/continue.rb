module Clarke::ActionController
  action 'continue' do
    sender = options[:event].sender
    user = User.find_by(messenger_id: sender)
    scenario = user.current_scenario
    scenario.update_next_step

    responses = continue_game_responses(user, scenario)

    responses.map do |continue_game_response|
      Clarke::Response.new(sender, continue_game_response)
    end
  end

  class << self
    def continue_game_responses(user, scenario)
      return handle_user_response(user, scenario) if scenario.waiting_for_reaction?
      []
    end

    def handle_user_response(user, scenario)
      response = scenario.parameters['response']
      scenario.update_next_step

      if response == Continue::Answers::YES
        new_scenario = Quiz.create(session: user.current_session)
        return ask_question(new_scenario)
      end

      text = []
      text << { text: I18n.t(:not_sure) } if response == Continue::Answers::MAYBE
      text << { text: I18n.t(:next_time) }
    end
  end
end
