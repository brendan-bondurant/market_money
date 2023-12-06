require 'rails_helper'

RSpec.describe "Market Money API" do
  describe 'single vendors' do
    it 'can show one vendor' do
      id = create(:vendor).id
      get "/api/v0/vendors/#{id}"
      expect(response).to be_successful
    end
  end
end
