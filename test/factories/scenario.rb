FactoryGirl.define do
  factory :scenario do
    session
  end

  factory :quiz, parent: :scenario, class: 'Quiz'
  factory :continue, parent: :scenario, class: 'Continue'
end
