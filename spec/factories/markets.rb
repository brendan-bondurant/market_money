FactoryBot.define do 
  factory :market do
    name { Faker::Company.name}
    name { Faker::Address.street}
    name { Faker::Address.city}
    name { Faker::Address.community}
    name { Faker::Address.state}
    name { Faker::Address.zip}
    name { Faker::Address.latitude}
    name { Faker::Address.longitude}
  end
end