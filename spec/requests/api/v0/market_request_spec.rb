require 'rails_helper'

describe "Market Money API" do
  it "sends a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful
  end
end