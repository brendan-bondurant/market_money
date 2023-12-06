require 'rails_helper'

describe "Market Money API" do
  it "sends a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'
    markets = JSON.parse(response.body)

    expect(response).to be_successful
    expect(markets.count).to eq(3)

    require 'pry'; binding.pry
  end
end