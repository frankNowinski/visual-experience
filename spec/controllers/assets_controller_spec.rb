require "rails_helper"

describe AssetsController, type: :controller do
  describe "#create" do
    let(:campaign) { create(:campaign) }

    context "with invalid params" do
      it "renders NEW template" do
        params = { campaign_id: campaign.id, asset: { name: nil } }

        expect(post :create, params: params).to render_template :new
      end
    end

    context "with valid params" do
      it "should create an asset" do
        asset_name = Faker::Company.buzzword
        params = {
          campaign_id: campaign.id,
          asset: {
            name: asset_name,
            campaign_id: campaign.id,
          }
        }

        post :create, params: params

        asset = campaign.reload.assets.last

        expect(asset.name).to eq asset_name
      end

      it "should create criteria for an asset" do
        order = 1
        image = Faker::Company.logo
        operand = Criterium::IPHONE
        criteria_type = "device"

        params = {
          campaign_id: campaign.id,
          asset: {
            name: "Asset Name",
            criteria_attributes: [
              {
                image: image,
                order: order,
                operand: operand,
                criteria_type: criteria_type,
              },
            ]
          }
        }

        post :create, params: params

        asset = campaign.reload.assets.last
        criteria = asset.criteria.first

        expect(criteria.image).to eq image
        expect(criteria.order).to eq order
        expect(criteria.operand).to eq operand
        expect(criteria.criteria_type).to eq criteria_type
      end

      it "should create nested criteria for criteria" do
        order = 1
        image = Faker::Company.logo
        operand = Criterium::IPHONE
        criteria_type = "device"
        nested_criteria_type = "nested"

        params = {
          campaign_id: campaign.id,
          asset: {
            name: "Asset Name",
            criteria_attributes: [
              {
                image: image,
                order: order,
                criteria_type: nested_criteria_type,
                nested_criteria_attributes: [
                  {
                    criteria_type: criteria_type,
                    operand: operand,
                  }
                ]
              },
            ]
          }
        }

        post :create, params: params

        asset = campaign.reload.assets.last
        criteria = asset.criteria.first
        nested_criteria = criteria.nested_criteria.first

        expect(criteria.image).to eq image
        expect(criteria.order).to eq order
        expect(criteria.criteria_type).to eq nested_criteria_type
        expect(nested_criteria.operand).to eq operand
        expect(nested_criteria.criteria_type).to eq criteria_type
      end
    end
  end

  describe "#update" do
    context "with invalid params" do
      it "renders EDIT template" do
        campaign = create(:campaign, :with_asset)
        asset = campaign.assets.first
        params = { id: asset.id, campaign_id: campaign.id, asset: { name: nil } }

        expect(put :update, params: params).to render_template :edit
      end
    end

    context "with valid params" do
      it "should update an asset" do
        campaign = create(:campaign, :with_asset)
        asset = campaign.assets.first
        updated_asset_name = Faker::Company.buzzword
        params = {
          id: asset.id,
          campaign_id: campaign.id,
          asset: {
            name: updated_asset_name,
          }
        }

        put :update, params: params

        expect(asset.reload.name).to eq updated_asset_name
      end

      it "should update criteria for an asset" do
        campaign = create(:campaign, :with_asset_and_criteria)
        asset = campaign.assets.first
        criteria = asset.criteria.first
        new_order = 5
        new_image = Faker::Company.logo
        new_operand = Criterium::ANDROID

        params = {
          id: asset.id,
          campaign_id: campaign.id,
          asset: {
            name: "Asset Name",
            criteria_attributes: [
              {
                id: criteria.id,
                image: new_image,
                order: new_order,
                operand: new_operand,
                criteria_type: "device",
              },
            ]
          }
        }

        put :update, params: params

        expect(criteria.reload.image).to eq new_image
        expect(criteria.order).to eq new_order
        expect(criteria.operand).to eq new_operand
      end

      it "should update nested criteria for criteria" do
        campaign = create(:campaign, :with_asset_and_nested_criteria)
        asset = campaign.assets.first
        criteria = asset.criteria.first
        nested_criteria = asset.criteria.first.nested_criteria.first
        new_operand = Criterium::ANDROID

        params = {
          id: asset.id,
          campaign_id: campaign.id,
          asset: {
            name: "Asset Name",
            criteria_attributes: [
              {
                id: criteria.id,
                nested_criteria_attributes: [
                  {
                    id: nested_criteria.id,
                    operand: new_operand,
                    criteria_type: "device",
                  }
                ]
              },
            ]
          }
        }

        put :update, params: params

        expect(nested_criteria.reload.operand).to eq new_operand
      end
    end
  end
end
