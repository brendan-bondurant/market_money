class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    new_mv = MarketVendor.new(market_vendor_params)
    render json: MarketVendorSerializer.new(new_mv), status: :created
  end

  private
  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end