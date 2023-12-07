class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    market_id = params[:market_id]
    vendor_id = params[:vendor_id]
    market = Market.find(market_id)
    vendor = Vendor.find(vendor_id)
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
  
  def not_valid_response(exception)
    if exception.message.include?("Market")
      render json: {
            "errors": [
                {
                    "status": "404",
                    "detail": "Validation failed: Market must exist"
                }
            ]
        }
    elsif exception.message.include?("Vendor")
      render json: {
        "errors": [
            {
                "status": "404",
                "detail": "Validation failed: Vendor must exist"
            }
        ]
    }
    # elsif
    #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    #     .serialize_json, status: :not_found
    end
  end

#   {
#     "errors": [
#         {
#             "detail": "Validation failed: Market must exist"
#         }
#     ]
# }