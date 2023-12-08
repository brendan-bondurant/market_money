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
    new_market.vendors << create_list(:vendor, 2)
    
    get "/api/v0/markets/#{new_market.id}/vendors"

    expect(response).to be_successful
    expect(new_market.vendors.count).to eq(2)
    
    vendors = JSON.parse(response.body, symbolize_names: true)[:data]
    vendors.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be(true).or be(false)

    end
  end
  it 'shows an error if invalid id' do

    get "/api/v0/markets/123412433124/vendors"
    # market = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=123412433124")
  end
  describe '#search' do
  
  it 'can search by state' do
    headers = {"CONTENT_TYPE" => "application/json"}
    market = create(:market)
    state = market.state
    
    get "/api/v0/markets/search", params: { state: state }, headers: headers
    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to have_http_status(200)
    
    expect(markets.first[:attributes]).to have_key(:state)
    expect(markets.first[:attributes][:state]).to eq(state)
    
  end
  it 'can search by name' do
    headers = {"CONTENT_TYPE" => "application/json"}
    market = create(:market)
    name = market.name
    
    get "/api/v0/markets/search", params: { name: name }, headers: headers
    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to have_http_status(200)
    
    expect(markets.first[:attributes]).to have_key(:name)
    expect(markets.first[:attributes][:name]).to eq(name)
    
  end
  it 'can search by state and city' do
    headers = {"CONTENT_TYPE" => "application/json"}
    market = create(:market)
    state = market.state
    city = market.city
    get "/api/v0/markets/search", params: { state: state, city: city }, headers: headers
    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to have_http_status(200)
    
    expect(markets.first[:attributes]).to have_key(:state)
    expect(markets.first[:attributes][:state]).to eq(state)
    expect(markets.first[:attributes]).to have_key(:city)
    expect(markets.first[:attributes][:city]).to eq(city)
    
  end
  it 'can search by state and name' do
    headers = {"CONTENT_TYPE" => "application/json"}
    market = create(:market)
    state = market.state
    name = market.name
    get "/api/v0/markets/search", params: { state: state, name: name }, headers: headers
    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to have_http_status(200)
    
    expect(markets.first[:attributes]).to have_key(:state)
    expect(markets.first[:attributes][:state]).to eq(state)
    expect(markets.first[:attributes]).to have_key(:name)
    expect(markets.first[:attributes][:name]).to eq(name)
  end
  it 'can search by city, state and name' do
    headers = {"CONTENT_TYPE" => "application/json"}
    market = create(:market)
    state = market.state
    city = market.city
    name = market.name
    get "/api/v0/markets/search", params: { state: state, name: name, city: city }, headers: headers
    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to have_http_status(200)
    
    expect(markets.first[:attributes]).to have_key(:state)
    expect(markets.first[:attributes][:state]).to eq(state)
    expect(markets.first[:attributes]).to have_key(:name)
    expect(markets.first[:attributes][:name]).to eq(name)
    expect(markets.first[:attributes]).to have_key(:city)
    expect(markets.first[:attributes][:city]).to eq(city)
  end
  it 'cannot search by city and name' do
    headers = {"CONTENT_TYPE" => "application/json"}
    market = create(:market)
    city = market.city
    name = market.name
    get "/api/v0/markets/search", params: { city: city, name: name }, headers: headers
    
    data = JSON.parse(response.body, symbolize_names: true)
    
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("422")
    expect(data[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
  end
end
  describe '#atm' do
    it 'can not find close atm if market id does not exist' do
      market = Market.new(id: 1234, name: "Union Square Greenmarket", street: "Union Square West", city: "New York", county: "New York", state: "NY", zip: "10003", lat: "40.7359", lon: "-73.9911")
      get "/api/v0/markets/#{market.id}/nearest_atms"
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=1234")
    end
    it 'can find close atm' do
      market = Market.create(id: 1234, name: "Union Square Greenmarket", street: "Union Square West", city: "New York", county: "New York", state: "NY", zip: "10003", lat: "40.7359", lon: "-73.9911")
      get "/api/v0/markets/#{market.id}/nearest_atms"
      get "/api/v0/markets/#{market.id}/nearest_atms"
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
    end
    it 'can find close atm' do
      market = Market.create(id: 1234, name: "Union Square Greenmarket", street: "Union Square West", city: "New York", county: "New York", state: "NY", zip: "10003", lat: "40.7359", lon: "-73.9911")
      get "/api/v0/markets/#{market.id}/nearest_atms"
      get "/api/v0/markets/#{market.id}/nearest_atms"
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(200)
      expect(data.first[:data][:attributes][:name]).to be_an(String)
      expect(data.first[:data][:attributes][:address]).to be_an(String)
      expect(data.first[:data][:attributes][:lat]).to be_an(Float)
      expect(data.first[:data][:attributes][:lon]).to be_an(Float)
      expect(data.first[:data][:attributes][:distance]).to be_an(Float)
      
    end
  
  end
  
end