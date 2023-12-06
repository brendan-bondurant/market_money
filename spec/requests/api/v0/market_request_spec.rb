require 'rails_helper'

describe "Market Money API" do
  it "sends a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'
    markets = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(markets.count).to eq(3)
    markets.each do |market|

      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_a(Integer)
    end
  end
  it 'shows a single market' do
    id = create(:market).id

    get "/api/v0/markets/#{id}"
    market = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(market).to have_key(:id)
    expect(market[:id]).to be_an(String)

    expect(market).to have_key(:id)
    expect(market[:id]).to be_an(String)

    expect(market[:attributes]).to have_key(:name)
    expect(market[:attributes][:name]).to be_a(String)

    expect(market[:attributes]).to have_key(:street)
    expect(market[:attributes][:street]).to be_a(String)

    expect(market[:attributes]).to have_key(:city)
    expect(market[:attributes][:city]).to be_a(String)

    expect(market[:attributes]).to have_key(:county)
    expect(market[:attributes][:county]).to be_a(String)

    expect(market[:attributes]).to have_key(:state)
    expect(market[:attributes][:state]).to be_a(String)

    expect(market[:attributes]).to have_key(:zip)
    expect(market[:attributes][:zip]).to be_a(String)

    expect(market[:attributes]).to have_key(:lat)
    expect(market[:attributes][:lat]).to be_a(String)

    expect(market[:attributes]).to have_key(:lon)
    expect(market[:attributes][:lon]).to be_a(String)

    expect(market[:attributes]).to have_key(:vendor_count)
    expect(market[:attributes][:vendor_count]).to be_a(Integer)
    
  end
  it 'shows an error if invalid id' do

    get "/api/v0/markets/123412433124"
    # market = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=123412433124")
  end
  it 'shows vendors for a market' do
    new_market = create(:market)

    get "/api/v0/markets/#{new_market.id}/vendors"

    expect(response).to be_successful

    # expect(market).to have_key(:id)
    # expect(market[:id]).to be_an(String)

    # expect(market).to have_key(:id)
    # expect(market[:id]).to be_an(String)

    # expect(market[:attributes]).to have_key(:name)
    # expect(market[:attributes][:name]).to be_a(String)

    # expect(market[:attributes]).to have_key(:street)
    # expect(market[:attributes][:street]).to be_a(String)

    # expect(market[:attributes]).to have_key(:city)
    # expect(market[:attributes][:city]).to be_a(String)

    # expect(market[:attributes]).to have_key(:county)
    # expect(market[:attributes][:county]).to be_a(String)

    # expect(market[:attributes]).to have_key(:state)
    # expect(market[:attributes][:state]).to be_a(String)

    # expect(market[:attributes]).to have_key(:zip)
    # expect(market[:attributes][:zip]).to be_a(String)

    # expect(market[:attributes]).to have_key(:lat)
    # expect(market[:attributes][:lat]).to be_a(String)

    # expect(market[:attributes]).to have_key(:lon)
    # expect(market[:attributes][:lon]).to be_a(String)

    # expect(market[:attributes]).to have_key(:vendor_count)
    # expect(market[:attributes][:vendor_count]).to be_a(Integer)
end
end