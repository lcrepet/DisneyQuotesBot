require "./test/test_helper"

class UsersTest < Test::Unit::TestCase
  test 'valid user' do
    user = build(:user, messenger_id: nil)
    assert !user.valid?

    user = build(:user)
    assert user.valid?
  end

end
