require 'rails_helper'

describe OrdersController, :type => :controller do

  describe "POST accept" do
    context "with a failed service call" do
      let(:mock_failing_service) { double('OrderAcceptanceService', accept_order: false)}

      it "accepts an order and returns 200" do

        # You can call inject dependencies at any point after construction. They will
        # be available for all before_actions
        controller.inject_dependencies(
          order_acceptance_service: mock_failing_service
        )

        post :accept_order, id: 4
        expect(response.status).to eq(400)
      end

      it "accepts an order and returns 200 but with different injection" do

        # But using the provided setter injection is easier
        controller.order_acceptance_service = mock_failing_service

        post :accept_order, id: 4
        expect(response.status).to eq(400)
      end
    end

    context "with a successful service call" do
      let(:mock_successful_service) { double('OrderAcceptanceService', accept_order: true)}

      it "accepts an order and returns 200" do

        controller.inject_dependencies(
          order_acceptance_service: mock_successful_service
        )

        post :accept_order, id: 4
        expect(response.status).to eq(200)
      end
    end
  end

  describe "POST decline" do
    it "declines an order" do
      post :decline_order, id: 4
      expect(response.status).to eq(200)
    end
  end
end
