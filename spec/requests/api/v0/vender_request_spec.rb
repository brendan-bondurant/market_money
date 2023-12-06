require 'rails_helper'

RSpec.describe "Market Money API" do
  describe 'single vendors' do
    it 'can show one vendor with valid id' do
      vendor1 = create(:vendor)
      id = vendor1.id
      get "/api/v0/vendors/#{id}"
      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)[:data]

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
    it 'gives an error for invalid id' do
      get "/api/v0/vendors/123412433124"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
  
      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=123412433124")
    end
  end
end
