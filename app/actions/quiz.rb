module Clarke::ActionController
  action 'quiz' do
    sender = options[:event].sender
    user = User.find_by(messenger_id: sender)
    scenario = user.current_scenario
    scenario.update_next_step

    responses = quiz_responses(scenario)

    responses.map do |quiz_response|
      Clarke::Response.new(sender, quiz_response)
    end
  end

  class << self
    def quiz_responses(scenario)
      return ask_question(scenario) if scenario.started?
      return compute_result(scenario) if scenario.waiting_for_result?
      []
    end

    def ask_question(scenario)
      quote = Quote.limit(1).order("RANDOM()").first
      return unless quote

      scenario.update_parameters(quote: quote.id)
      scenario.update_next_step
      [ { text: quote.line }]
    end

    def compute_result(scenario)
      quote = Quote.find(scenario.parameters['quote'])
      user_response = scenario.parameters['response']
      correct_response = quote.movie.title_fr.downcase

      result = (user_response == correct_response) ? :true : :false
      scenario.update_parameters(result: result)
      scenario.update_next_step
      return react_to_result(quote, scenario)
    end

    def react_to_result(quote, scenario)
      return send_clue(quote, scenario) if scenario.waiting_for_clue?

      Continue.create(session: scenario.session)
      return [ { text: I18n.t(:you_lose, answer: quote.movie.title_fr ) }, { text: I18n.t(:want_to_replay) }] if scenario.parameters['result'] == 'false'
      [ { text: I18n.t(:you_win) }, { text: I18n.t(:want_to_replay) }]
    end

    def send_clue(quote, scenario)
      scenario.update_parameters(clue: 1)
      scenario.update_next_step

      clue = GifSearch.get_random_gif_from(quote.movie.title_en.downcase)

      [
        {
          text: I18n.t(:try_again),
          image: {
            url: clue
          }
        }
      ]
    end
  end
end
