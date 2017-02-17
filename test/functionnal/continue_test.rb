require "./test/test_helper"

class QuizTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @session = create(:session)
    @event = Clarke::Messenger::Events::TextMessage.new(1234567, @session.user.messenger_id, Time.now.getutc, '')
  end

  def teardown
    Scenario.delete_all
    User.delete_all
    Session.delete_all
  end

  test 'handle yes response' do
    scenario = create(:continue, session: @session)
    scenario.update_parameters(response: Continue::Answers::YES)
    response = Clarke::ActionController.process(Clarke::ActionRequest.new('continue', @event, scenario.parameters)).first
    assert response.text

    assert @session.last_scenario.is_a?(Quiz)
  end

  test 'handle no response' do
    scenario = create(:continue, session: @session)
    scenario.update_parameters(response: Continue::Answers::NO)
    responses = Clarke::ActionController.process(Clarke::ActionRequest.new('continue', @event, scenario.parameters))
    assert_equal 1, responses.count
    assert_equal I18n.t(:next_time), responses.first.text

    assert @session.last_scenario.nil?
  end

  test 'handle maybe response' do
    scenario = create(:continue, session: @session)
    scenario.update_parameters(response: Continue::Answers::MAYBE)
    responses = Clarke::ActionController.process(Clarke::ActionRequest.new('continue', @event, scenario.parameters))
    assert_equal 2, responses.count
    assert_equal I18n.t(:not_sure), responses.first.text
    assert_equal I18n.t(:next_time), responses.second.text

    assert @session.last_scenario.nil?
  end
end
