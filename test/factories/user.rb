FactoryGirl.define do
  factory :user do
    sequence(:messenger_id) { |n| n }
  end
end
