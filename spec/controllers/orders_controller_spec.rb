require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  describe "POST accept" do
    it "accepts an order" do
      post :accept_order, id: 4
      expect(response.status).to eq(200)
    end
  end

  describe "POST decline" do
    it "declines an order" do
      post :decline_order, id: 4
      expect(response.status).to eq(200)
    end
  end
end
