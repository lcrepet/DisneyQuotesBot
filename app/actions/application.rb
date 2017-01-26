module Clarke::ActionController
  action 'send_response' do
    sender = options[:event].sender
    response = options[:response]
    Clarke::Response.new(sender, {text: response})
  end

  action 'send_help' do
    sender = options[:event].sender
    Clarke::Response.new(sender, {text: I18n.t(:help)})
  end

  action 'welcome' do
    sender = options[:event].sender
    Clarke::Response.new(sender, { text: I18n.t(:welcome) })
  end

  class << self

    private

    def end_scenario(user, message_options)
      user.current_session.last_scenario.terminate
      message_options
    end

    def update_scenario(user, message_options, params={})
      user.current_session.last_scenario.update_parameters(params)
      user.current_session.last_scenario.update_next_step
      message_options
    end

    def get_sentence(name:, prefix: nil, params: {}, nb_alternatives: 3)
      nb = rand(nb_alternatives)
      chosen_sentence_title = prefix ? "#{prefix}.#{name}_#{nb}" : "#{name}_#{nb}"
      I18n.t(chosen_sentence_title.to_sym, params)
    end
  end
end

