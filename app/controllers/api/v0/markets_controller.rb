class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def nearest_atms
    require 'pry'; binding.pry
  end

  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
  end
    
  def search
    if params[:state].present? && params[:city].present? && params[:name].present?
      markets = Market.where(state: params[:state], city: params[:city], name: params[:name])
      render json: MarketSerializer.new(markets)
    elsif
      params[:state].present? && params[:city].present?
      markets = Market.where(state: params[:state], city: params[:city])
      render json: MarketSerializer.new(markets)
    elsif
      params[:state].present? && params[:name].present?
      markets = Market.where(state: params[:state], name: params[:name])
      render json: MarketSerializer.new(markets)
    elsif
      params[:name].present? && params[:city].present? == false
      markets = Market.where(name: params[:name])
      render json: MarketSerializer.new(markets)
    elsif
      params[:state].present?
      markets = Market.where(state: params[:state])
      render json: MarketSerializer.new(markets)
    elsif params[:city].present? || (params[:city].present? && params[:name].present?)
      render json: {
            "errors": [
                {
                    "status": "422",
                    "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
                }
            ]
        }, status: :unprocessable_entity
    else
      render json: MarketSerializer.new(Market.all)
    end
  end
    
  end
  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
