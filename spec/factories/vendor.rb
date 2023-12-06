FactoryBot.define do 
  factory :vendor do
    name { Faker::Company.name }
    description { Faker::Marketing.buzzwords }
    contact_name { Faker::BossaNova.artist }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end