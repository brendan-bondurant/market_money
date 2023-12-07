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
end