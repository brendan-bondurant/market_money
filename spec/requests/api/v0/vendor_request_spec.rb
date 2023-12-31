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
  describe '#create' do
    it 'can create a vendor' do
      vendor_params = ({
                        name: 'Test Vendor',
                        description: 'We sell things',
                        contact_name: 'Brendan',
                        contact_phone: '123-4567',
                        credit_accepted: true
                      })
      headers = {"CONTENT_TYPE" => "application/json"}  
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      new_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to be_successful
      expect(response).to have_http_status(201)
      expect(new_vendor[:attributes][:name]).to eq(vendor_params[:name])
      expect(new_vendor[:attributes][:description]).to eq(vendor_params[:description])
      expect(new_vendor[:attributes][:contact_name]).to eq(vendor_params[:contact_name])
      expect(new_vendor[:attributes][:contact_phone]).to eq(vendor_params[:contact_phone])
      expect(new_vendor[:attributes][:credit_accepted]).to eq(vendor_params[:credit_accepted])
    end
    it 'gives an error if information is missing' do
      vendor_params = ({
                        name: 'Test Vendor',
                        description: 'We sell things',
                        contact_name: 'Brendan',
                        # contact_phone: '123-4567',
                        credit_accepted: true
                      })
      headers = {"CONTENT_TYPE" => "application/json"}  
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(data[:errors].first[:detail]).to eq("Contact phone can't be blank")
    end
    it 'gives an error if more information is missing' do
      vendor_params = ({
        name: 'Test Vendor',
        description: 'We sell things',
        # contact_name: 'Brendan',
        # contact_phone: '123-4567',
        credit_accepted: true
      })
      headers = {"CONTENT_TYPE" => "application/json"}  
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      new_vendor = Vendor.last
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(data[:errors].first[:detail]).to eq("Contact name can't be blank, Contact phone can't be blank")
    end
  end
  describe '#update' do
    it 'can update the name' do
      vendor_update = create(:vendor)
      id = vendor_update.id
      previous_name = vendor_update[:name]
      vendor_params = {
        id: 321,
        name: "New Name",
        description: "synergy",
        contact_name: "Roberto Menescal",
        contact_phone: "376-037-5055 x821",
        credit_accepted: true
      }

      headers = {"CONTENT_TYPE" => "application/json"}  
      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)
      updated_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(updated_vendor[:attributes][:name]).to_not eq(previous_name)
      expect(updated_vendor[:attributes][:name]).to eq(vendor_params[:name])
    end
    it 'cannot update with invalid id' do
      vendor_update = create(:vendor)
      id = vendor_update.id = 123456789
      previous_name = vendor_update[:name]
      vendor_params = {
        id: 321,
        name: "New Name",
        description: "synergy",
        contact_name: "Roberto Menescal",
        contact_phone: "376-037-5055 x821",
        credit_accepted: true
      }
      headers = {"CONTENT_TYPE" => "application/json"}  
      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=123456789")
    end
  
    it 'gives an error if information is missing' do
      vendor_update = create(:vendor)
      previous_name = vendor_update[:name]
      vendor_params = {
        id: 321,
        name: nil,
        description: "synergy",
        contact_name: "Roberto Menescal",
        contact_phone: "376-037-5055 x821",
        credit_accepted: true
      }
      headers = {"CONTENT_TYPE" => "application/json"}  
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      new_vendor = Vendor.last
      data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(400)
      expect(data[:errors].first[:detail]).to eq("Name can't be blank")
    end
  end
  describe '#delete' do
    it 'can remove a vendor' do
      vendor_to_delete = create(:vendor)
      id = vendor_to_delete.id
      delete "/api/v0/vendors/#{id}"
      expect(response).to have_http_status(204)
    
    end
  
  end
end
