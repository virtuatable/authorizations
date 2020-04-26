FactoryBot.define do
  factory :empty_session, class: Arkaan::Authentication::Session do
    factory :session do
      token { Faker::Alphanumeric.alpha(number: 36) }
    end
  end
end