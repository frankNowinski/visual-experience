require "rails_helper"

describe Campaign do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
  end

  describe "#duplicate" do
    it "should create a new campaign record" do
      original_campaign = create(:campaign)
      dup_campaign = original_campaign.duplicate

      expect(original_campaign.name).to eq dup_campaign.name
      expect(original_campaign.user).to eq dup_campaign.user
    end

    context "when the campaign has an associated asset" do
      it "should duplciate the campaign asset" do
        original_campaign = create(:campaign, :with_asset)
        dup_campaign = original_campaign.duplicate

        expect(original_campaign.assets.first.name).to eq dup_campaign.assets.first.name
      end
    end

    context "when the campaign's asset has criteria" do
      it "should duplciate the asset's criteria" do
        original_campaign = create(:campaign, :with_asset_and_criteria)
        dup_campaign = original_campaign.duplicate

        original_criteria = original_campaign.assets.first.criteria.first
        dup_criteria = dup_campaign.assets.first.criteria.first

        expect(original_criteria.image).to eq dup_criteria.image
        expect(original_criteria.order).to eq dup_criteria.order
        expect(original_criteria.operand).to eq dup_criteria.operand
        expect(original_criteria.criteria_type).to eq dup_criteria.criteria_type
      end
    end

    context "when the asset's criteria has nested criteria" do
      it "should duplciate the criteria's nested criteria" do
        original_campaign = create(:campaign, :with_asset_and_nested_criteria)
        dup_campaign = original_campaign.duplicate

        orig_nested_criteria = original_campaign.assets.first.criteria.first.nested_criteria.first
        dup_nested_criteria = dup_campaign.assets.first.criteria.first.nested_criteria.first

        expect(orig_nested_criteria.operand).to eq dup_nested_criteria.operand
        expect(orig_nested_criteria.criteria_type).to eq dup_nested_criteria.criteria_type
      end
    end
  end
end

