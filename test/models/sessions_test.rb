require "./test/test_helper"

class SessionsTest < Test::Unit::TestCase
  test 'valid session' do
    session = build(:session, start_datetime: nil)
    assert !session.valid?

    session = build(:session, user: nil)
    assert !session.valid?

    session = build(:session)
    assert session.valid?
  end
end
