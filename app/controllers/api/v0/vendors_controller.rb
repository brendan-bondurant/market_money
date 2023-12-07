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
    new_vendor = Vendor.new(vendor_params)
    if new_vendor.save
      render json: VendorSerializer.new(new_vendor), status: :created
    else
      render json: ErrorSerializer.new(ErrorMessage.new(new_vendor.errors.full_messages.join(", "), 400))
        .serialize_json, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update(vendor_params)
    render json: VendorSerializer.new(vendor)
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

  # def bad_request_response(exception)
  #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
  #   .serialize_json, status: :not_found
  # end

  # def required_params
  #   ["name", "description", "contact_name", "contact_phone", "credit_accepted"]
  # end
  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

end