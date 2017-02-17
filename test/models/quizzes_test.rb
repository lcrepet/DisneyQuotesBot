require "./test/test_helper"

class QuizzesTest < Test::Unit::TestCase

  test 'make sense of' do
    scenario = create(:quiz)

    scenario.make_sense_of('hi')
    scenario.reload
    assert_equal 'hi', scenario.parameters['input']

    scenario.update_parameters(quote: 1)

    assert scenario.wait_for_response
    scenario.make_sense_of('response')
    scenario.reload
    assert_equal 'response', scenario.parameters['response']
    assert_equal 1, scenario.parameters['nb_attempts']

    assert scenario.wait_for_result
    scenario.update_parameters(result: 'false')

    assert scenario.wait_for_clue
    scenario.update_parameters(clue: 1)

    assert scenario.wait_for_response
    scenario.make_sense_of('second response')
    scenario.reload
    assert_equal 'second response', scenario.parameters['response']
    assert_equal 2, scenario.parameters['nb_attempts']
  end

  test 'update next step' do
    scenario = create(:quiz)
    assert scenario.started?

    scenario.update_parameters(quote: 1)
    scenario.update_next_step
    assert scenario.waiting_for_response?

    scenario.update_parameters(response: 'response')
    scenario.update_next_step
    assert scenario.waiting_for_result?

    scenario.update_parameters(result: 'false', nb_attempts: 1)
    scenario.update_next_step
    assert scenario.waiting_for_clue?

    scenario.update_parameters(clue: 1)
    scenario.update_next_step
    assert scenario.waiting_for_response?

    scenario.update_parameters(response: 'response')
    scenario.update_next_step
    assert scenario.waiting_for_result?

    scenario.update_parameters(result: 'false', nb_attempts: 2)
    scenario.update_next_step
    assert scenario.done?

    scenario.aasm_state = :waiting_for_result
    scenario.update_parameters(result: 'true', nb_attempts: 1)
    scenario.update_next_step
    assert scenario.done?
  end
end
