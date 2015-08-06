FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }

    trait :password do
      password              { "test" }
    end

    trait :activation_state do
      activation_state { "active" }
    end

    factory :user_with_password,    traits: [:password]
    factory :active_user_with_password,    traits: [:activation_state, :password]

  end
end