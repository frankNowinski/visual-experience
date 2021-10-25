FactoryBot.define do
  factory :criterium do
    order { rand(1..5) }
    operand { "iphone" }
    criteria_type { "device" }
    image { Faker::Company.logo }
    asset
  end
end
