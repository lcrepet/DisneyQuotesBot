require "./test/test_helper"

class ContinuesTest < Test::Unit::TestCase

  test 'make sense of' do
    scenario = create(:continue)

    scenario.make_sense_of('oui')
    scenario.reload
    assert_equal Continue::Answers::YES, scenario.parameters['response']

    scenario.make_sense_of('non')
    scenario.reload
    assert_equal Continue::Answers::NO, scenario.parameters['response']

    scenario.update_parameters(response: nil)
    scenario.make_sense_of('test')
    scenario.reload
    assert_equal Continue::Answers::MAYBE, scenario.parameters['response']
  end

  test 'update next step' do
    scenario = create(:continue)
    assert scenario.started?

    scenario.update_parameters(response: 'oui')
    scenario.update_next_step
    assert scenario.waiting_for_reaction?
  end
end
