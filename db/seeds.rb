# Array of ints to randomly set criteria order
order_counter = (1..5).to_a

# Array of operands
operands = Criterium::OPERANDS

# Create User
user = User.create!(email: Faker::Internet.email)

# Create Campaign
campaign = user.campaigns.create!(name: Faker::Company.name)

# Create Campaign Asset
asset = campaign.assets.create!(name: Faker::Company.buzzword)

# Create nested Criterium
nested_criterium = asset.criteria.create!(
  criteria_type: "nested",
  image: Faker::Company.logo,
  order: order_counter.pop
)

# Create between 1 to 3 associated nested Criteria
rand(1..3).times do |i|
  operand = operands.delete(operands.sample)
  nested_criterium.nested_criteria.create!(criteria_type: "device", operand: operand)
end

# Create Criteria for remaining operands
operands.each do |operand|
  asset.criteria.create!(
    criteria_type: "device",
    operand: operand,
    image: Faker::Company.logo,
    order: order_counter.pop
  )
end

# Create criterium with criteria_type of "always"
asset.criteria.create!({
  criteria_type: "always",
  image: Faker::Company.logo,
  order: 1000
})
