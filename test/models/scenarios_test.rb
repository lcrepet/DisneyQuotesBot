require "./test/test_helper"

class ScenariosTest < Test::Unit::TestCase

  def setup
    @scenario = create(:scenario)
  end

  test 'valid scenario' do
    scenario = build(:scenario, session: nil)
    assert !scenario.valid?

    scenario = build(:scenario)
    assert scenario.valid?
  end

  test 'update parameters' do
    assert !@scenario.parameters['key']

    assert @scenario.update_parameters(key: 'value')
    assert_equal 'value', @scenario.parameters['key']
  end
end
