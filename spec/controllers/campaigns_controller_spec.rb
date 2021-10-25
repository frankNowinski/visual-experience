require "rails_helper"

describe CampaignsController, type: :controller do
  describe "#show" do
    it "renders SHOW template" do
      user = User.create!(email: Faker::Internet.email)
      campaign = user.campaigns.create!(name: Faker::Company)

      expect(get :show, params: { id: campaign.id }).to render_template :show
    end
  end

  describe "#create" do
    context "with invalid params" do
      it "renders NEW template" do
        params = { campaign: { invalid_params: false } }

        expect(post :create, params: params).to render_template :new
      end
    end

    context "with valid params" do
      let(:user) { User.create!(email: Faker::Internet.email) }

      it "should create a campaign" do
        campaign_name = Faker::Company.name
        params = {
          campaign: {
            user_id: user.id,
            name: campaign_name,
          }
        }

        post :create, params: params

        campaign = user.campaigns.last

        expect(campaign.name).to eq campaign_name
      end

      it "should create an asset" do
        asset_name = Faker::Company.buzzword
        params = {
          campaign: {
            user_id: user.id,
            name: "Campaign Name",
            assets_attributes: [{ name: asset_name }]
          }
        }

        post :create, params: params

        asset = user.campaigns.last.assets.first

        expect(asset.name).to eq asset_name
      end

      it "should create criteria for an asset" do
        order = 1
        image = Faker::Company.logo
        operand = Criterium::IPHONE
        criteria_type = "device"

        params = {
          campaign: {
            user_id: user.id,
            name: "Campaign Name",
            assets_attributes: [
              {
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
            ]
          }
        }

        post :create, params: params

        asset = user.campaigns.last.assets.first
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
          campaign: {
            user_id: user.id,
            name: "Campaign Name",
            assets_attributes: [
              {
                name: "Asset Name",
                criteria_attributes: [
                  {
                    image: image,
                    order: order,
                    criteria_type: nested_criteria_type,
                    nested_criteria_attributes: [
                      {
                        criteria_type: "device",
                        operand: operand,
                      }
                    ]
                  },
                ]
              },
            ]
          }
        }

        post :create, params: params

        asset = user.campaigns.last.assets.first
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
    let(:user) { User.create!(email: Faker::Internet.email) }
    let(:campaign) { user.campaigns.create(name: Faker::Company.name) }

    context "with invalid params" do
      it "renders EDIT template" do
        params = { id: campaign.id, campaign: { user_id: nil } }

        expect(put :update, params: params).to render_template :edit
      end
    end

    context "with valid params" do
      it "should update a campaign" do
        updated_campaign_name = Faker::Company.name
        params = {
          id: campaign.id,
          campaign: {
            name: updated_campaign_name,
          }
        }

        put :update, params: params

        expect(campaign.reload.name).to eq updated_campaign_name
      end

      it "should update an asset" do
        asset = campaign.assets.create!(name: Faker::Company.buzzword)
        updated_asset_name = Faker::Company.buzzword
        params = {
          id: campaign.id,
          campaign: {
            name: "Campaign Name",
            assets_attributes: [{ id: asset.id, name: updated_asset_name }]
          }
        }

        put :update, params: params

        expect(asset.reload.name).to eq updated_asset_name
      end

      it "should update criteria for an asset" do
        asset = campaign.assets.create!(name: Faker::Company.buzzword)
        criteria = asset.criteria.create!(
          order: 1,
          image: Faker::Company.logo,
          operand: Criterium::IPHONE,
          criteria_type: "device",
        )
        new_order = 5
        new_image = Faker::Company.logo
        new_operand = Criterium::ANDROID

        params = {
          id: campaign.id,
          campaign: {
            name: "Campaign Name",
            assets_attributes: [
              {
                id: asset.id,
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
            ]
          }
        }

        put :update, params: params

        expect(criteria.reload.image).to eq new_image
        expect(criteria.order).to eq new_order
        expect(criteria.operand).to eq new_operand
      end

      it "should update nested criteria for criteria" do
        asset = campaign.assets.create!(name: Faker::Company.buzzword)
        criteria = asset.criteria.create!(
          order: 1,
          image: Faker::Company.logo,
          criteria_type: "nested",
        )
        nested_criteria = criteria.nested_criteria.create!(
          operand: Criterium::IPHONE,
          criteria_type: "device",
        )

        new_operand = Criterium::ANDROID

        params = {
          id: campaign.id,
          campaign: {
            name: "Campaign Name",
            assets_attributes: [
              {
                id: asset.id,
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
            ]
          }
        }

        put :update, params: params

        expect(nested_criteria.reload.operand).to eq new_operand
      end
    end
  end
end
