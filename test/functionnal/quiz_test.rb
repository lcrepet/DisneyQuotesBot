require "./test/test_helper"

class QuizTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @session = create(:session)
    @event = Clarke::Messenger::Events::TextMessage.new(1234567, @session.user.messenger_id, Time.now.getutc, '')
    @quote = create(:quote)
  end

  def teardown
    Scenario.delete_all
    User.delete_all
    Session.delete_all
    Quote.delete_all
    Movie.delete_all
  end

  test 'give quote' do
    scenario = create(:quiz, session: @session)
    response = Clarke::ActionController.process(Clarke::ActionRequest.new('quiz', @event, scenario.parameters)).first
    assert_equal response.text, @quote.line
  end

  test 'react to good answer' do
    scenario = create(:quiz, session: @session)
    scenario.update_parameters(quote: @quote.id, response: @quote.movie.title_fr.downcase, nb_attempts: 1)
    scenario.update(aasm_state: :waiting_for_response)
    responses = Clarke::ActionController.process(Clarke::ActionRequest.new('quiz', @event, scenario.parameters))
    assert_equal 2, responses.count
    assert_equal I18n.t(:you_win), responses.first.text
    assert_equal I18n.t(:want_to_replay), responses.second.text

    assert @session.last_scenario.is_a?(Continue)
  end

  test 'tract to first bad answer' do
    scenario = create(:quiz, session: @session)
    scenario.update_parameters(quote: @quote.id, response: 'wrong answer', nb_attempts: 1)
    scenario.update(aasm_state: :waiting_for_response)
    responses = Clarke::ActionController.process(Clarke::ActionRequest.new('quiz', @event, scenario.parameters))
    assert_equal 1, responses.count
    assert responses.first.image
  end

  test 'react to last bad answer' do
    scenario = create(:quiz, session: @session)
    scenario.update_parameters(quote: @quote.id, response: 'wrong answer', nb_attempts: Quiz::MAX_NB_ATTEMPTS)
    scenario.update(aasm_state: :waiting_for_response)
    responses = Clarke::ActionController.process(Clarke::ActionRequest.new('quiz', @event, scenario.parameters))
    assert_equal 2, responses.count
    assert_equal I18n.t(:you_lose, answer: @quote.movie.title_fr), responses.first.text
    assert_equal I18n.t(:want_to_replay), responses.second.text

    assert @session.last_scenario.is_a?(Continue)
  end
end
