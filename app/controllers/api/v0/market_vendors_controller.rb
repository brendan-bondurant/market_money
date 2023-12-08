class Api::V0::MarketVendorsController < ApplicationController
  
  def destroy
    market_id = params[:market_vendor][:market_id]
    vendor_id = params[:market_vendor][:vendor_id]
    # require 'pry'; binding.pry
    mv = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
    if mv.is_a?(MarketVendor)
      mv.destroy
    else
      render json: {
        "errors": [
          {
            status: "404",
            detail: "No MarketVendor with market_id=#{market_id} AND a vendor_id=#{vendor_id}"
          }
        ]
      }, status: :not_found
  end
end

  def create
    # market_id = params[:market_id]
    # vendor_id = params[:vendor_id]
    market = Market.find(params[:market_id])
    vendor = Vendor.find(params[:vendor_id])
    new_mv = MarketVendor.new(market_vendor_params)
    new_mv.save
    render json: MarketVendorSerializer.new(new_mv), status: :created
    # else
    #   render json: ErrorSerializer.new(ErrorMessage.new(new_mv.errors.full_messages.join(", "), 422))
    #     .serialize_json, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => exception
      not_valid_response(exception)
    end
  end

  private
  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  # def not_mv
  #   market_id = params[:market_vendor][:market_id]
  #   vendor_id = params[:market_vendor][:vendor_id]
  #   render json: {
  #     "errors": [
  #       {
  #         "detail": "No MarketVendor with market_id=#{market_id} AND a vendor_id=#{vendor_id}"
  #       }
  #     ]
  #   }, status: :not_found
  # end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
  
  def not_valid_response(exception)
    if exception.message.include?("Market")
      render json: {
            "errors": [
                {
                    "status": "404",
                    "detail": "Validation failed: Market must exist"
                }
            ]
        }, status: :not_found
    elsif exception.message.include?("Vendor")
      render json: {
        "errors": [
            {
                "status": "404",
                "detail": "Validation failed: Vendor must exist"
            }
        ]
    }, status: :not_found
    # elsif
    #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    #     .serialize_json, status: :not_found
    end
  end
# end
#   {
#     "errors": [
#         {
#             "detail": "Validation failed: Market must exist"
#         }
#     ]
# }