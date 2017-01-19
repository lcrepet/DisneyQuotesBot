require 'test_helper'

class FactoriesTest < Test::Unit::TestCase
  FactoryGirl.factories.map(&:name).each do |factory_name|
    test "#{factory_name} factory" do
      object = build(factory_name)
      assert object.valid?, object.errors.full_messages.join('|')
    end
  end
end
