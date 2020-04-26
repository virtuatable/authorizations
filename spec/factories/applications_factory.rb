FactoryBot.define do
  factory :empty_application, class: Arkaan::OAuth::Application do
    factory :application do
      name { Faker::Alphanumeric.unique.alpha(number: 20) }
      key { Faker::Internet.domain_word } 
    end
  end
end