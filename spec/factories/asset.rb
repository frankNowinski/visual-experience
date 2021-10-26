FactoryBot.define do
  factory :asset do
    name { Faker::Company.buzzword }
    campaign
  end
end
