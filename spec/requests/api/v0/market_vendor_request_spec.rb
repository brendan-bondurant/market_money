require 'rails_helper'

RSpec.describe "Market Vendor" do
  it 'should create a new association' do
    headers = {"CONTENT_TYPE" => "application/json"}  
    market = create(:market)
    vendor = create(:vendor)
    post '/api/v0/market_vendors', params: { market_id: market.id, vendor_id: vendor.id }.to_json, headers: headers
    new_association = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to have_http_status(201)
    expect(new_association[:attributes][:market_id]).to eq(market.id)
    expect(new_association[:attributes][:vendor_id]).to eq(vendor.id)
  end
  it 'will fail if there is an invalid id' do

    post '/api/v0/market_vendors', params: { market_id: "123456789", vendor_id: "123456789" }, headers: headers
    data = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:detail]).to eq("Validation failed: Market must exist")
  
  end
end