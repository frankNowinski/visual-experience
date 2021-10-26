class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.find(params[:id])
  end

  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to @campaign
    else
      render :new
    end
  end

  def update
    @campaign = Campaign.find(params[:id])

    if @campaign.update(campaign_params)
      redirect_to @campaign
    else
      render :edit
    end
  end

  def duplicate
    campaign = Campaign.find(params[:campaign_id])
    dup_campaign = campaign.duplicate

    if dup_campaign.save
      redirect_to dup_campaign
    else
      redirect_to campaign
    end
  end

  private

  def campaign_params
    params
      .require(:campaign)
      .permit(
        :name,
        :user_id,
        assets_attributes: [
          :id,
          :name,
          criteria_attributes: [
            :id,
            :image,
            :order,
            :operand,
            :criteria_type,
            nested_criteria_attributes: [:id, :operand, :criteria_type]
          ]
        ]
      )
  end
end
