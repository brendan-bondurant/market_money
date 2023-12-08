class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def nearest_atms
    market = Market.find(params[:id])
    lat = market.lat
    lon = market.lon
    conn = Faraday.new("https://api.tomtom.com") do |faraday|
      faraday.params["lat"] = lat
      faraday.params["lon"] = lon
      faraday.params["key"] = Rails.application.credentials.tomtom[:key]
    end
    response = conn.get("/search/2/search/cash_dispenser.json")
    data = JSON.parse(response.body, symbolize_names: true)
    distance = data[:results].sort_by { |atm| atm[:dist] }

    nearest_atms = distance.map do |atm|
      {
        id: nil,
        type: 'atm',
        attributes: {
          name: atm[:poi][:name],
          address: atm[:address][:streetNumber] + " " + atm[:address][:streetName],
          lat: atm[:position][:lat],
          lon: atm[:position][:lon],
          distance: atm[:dist]
        }
      }
    end
    
    render json: { data: nearest_atms }


    rescue Faraday::ConnectionFailed
      :not_found_response
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
