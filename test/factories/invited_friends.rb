FactoryGirl.define do
  factory :invited_friend do
    association :user, factory: :active_user_with_password
    email { Faker::Internet.email }
    invite_token { ::Sorcery::Model::TemporaryToken.generate_random_token }
    invite_last_send_at Time.now.in_time_zone
  end
end
