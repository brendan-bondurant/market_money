class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(Vendor.all)
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    new_vendor = Vendor.create(vendor_params)
    if new_vendor.valid?
      render json: VendorSerializer.new(new_vendor), status: :created
    else
      missing_params = required_params - vendor_params.keys
      render json: { error: "Validation failed: #{missing_params.join(', ')} can't be blank" }, status: 400
    end
  end

  # def create
  #   require 'pry'; binding.pry
  #   new_vendor = Vendor.create(vendor_params)
  #   render json: VendorSerializer.new(new_vendor), status: :created
  # end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def bad_request_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    .serialize_json, status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def required_params
    ["name", "description", "contact_name", "contact_phone", "credit_accepted"]
  end
end