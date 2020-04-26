FactoryBot.define do
  factory :empty_application, class: Arkaan::OAuth::Application do
    factory :application do
      name { 'virtuatable' }
      key { 'virtuatable'} 
    end
  end
end