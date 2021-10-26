require "rails_helper"

describe CampaignsController, type: :controller do
  describe "#show" do
    it "renders SHOW template" do
      campaign = create(:campaign)

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
      let(:user) { create(:user) }

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
                        criteria_type: criteria_type,
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
    context "with invalid params" do
      it "renders EDIT template" do
        campaign = create(:campaign)
        params = { id: campaign.id, campaign: { user_id: nil } }

        expect(put :update, params: params).to render_template :edit
      end
    end

    context "with valid params" do
      it "should update a campaign" do
        campaign = create(:campaign)
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
        campaign = create(:campaign, :with_asset)
        asset = campaign.assets.first
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
        campaign = create(:campaign, :with_asset_and_criteria)
        asset = campaign.assets.first
        criteria = asset.criteria.first
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
        campaign = create(:campaign, :with_asset_and_nested_criteria)
        asset = campaign.assets.first
        criteria = asset.criteria.first
        nested_criteria = criteria.nested_criteria.first
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

  describe "#duplicate" do
    let(:campaign) { create(:campaign) }

    subject { post :duplicate, params: { campaign_id: campaign.id } }

    context "when the campaign is NOT duplicated" do
      it "redirects to the SHOW action with the original campaign" do
        allow(Campaign).to receive(:find).and_return(campaign)
        allow(campaign).to receive(:duplicate).and_return(double(save: false))

        expect(subject).to redirect_to campaign_path(campaign)
      end
    end

    context "when the campaign is duplicated" do
      it "redirects to the SHOW action with the duplicated campaign" do
        user = campaign.user
        expect(subject).to redirect_to campaign_path(user.campaigns.last)
      end
    end
  end
end
