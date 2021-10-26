FactoryBot.define do
  factory :campaign do
    name { Faker::Company.name }
    user
  end

  trait :with_asset do
    after(:create) do |campaign|
      create(:asset, campaign: campaign)
    end
  end

  trait :with_asset_and_criteria do
    after(:create) do |campaign|
      asset = create(:asset, campaign: campaign)
      asset.criteria << create(:criterium)
    end
  end

  trait :with_asset_and_nested_criteria do
    after(:create) do |campaign|
      asset = create(:asset, campaign: campaign)
      criterium = create(:criterium, criteria_type: "nested")
      criterium.nested_criteria << create(:criterium)
      asset.criteria << criterium
    end
  end
end
