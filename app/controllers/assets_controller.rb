class AssetsController < ApplicationController
  def show
    @asset = Asset.find(params[:id])
  end

  def create
    campaign = Campaign.find(params[:campaign_id])

    if campaign.assets.new(asset_params).save
      render :show
    else
      render :new
    end
  end

  def update
    @asset = Asset.find_by(id: params[:id], campaign_id: params[:campaign_id])

    if @asset&.update(asset_params)
      render :show
    else
      render :edit
    end
  end

  private

  def asset_params
    params
      .require(:asset)
      .permit(
        :name,
        criteria_attributes: [
          :id,
          :image,
          :order,
          :operand,
          :criteria_type,
          nested_criteria_attributes: [:id, :operand, :criteria_type]
        ]
      )
  end
end
