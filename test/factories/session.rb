FactoryGirl.define do
  factory :session do
    start_datetime Time.now
    user
  end
end
