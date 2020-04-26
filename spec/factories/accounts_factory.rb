FactoryBot.define do
  factory :empty_account, class: Arkaan::Account do
    factory :babausse do
      username { 'Babausse' }
      password { 'password' }
      password_confirmation { 'password' }
      email { 'test@virtuatable.io' }
    end
  end
end