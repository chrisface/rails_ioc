require 'rails_helper'

describe OrderAcceptanceService do
  subject { OrderAcceptanceService.build }

  context ".build" do
    it "can be instantiated" do
      expect(subject.class).to eq(OrderAcceptanceService)
    end

    context "dependency injection!" do
      let(:mock_billing_service) { { hehe: 'lol' } }

      it "can override a dependency" do
        oms = OrderAcceptanceService.build(
          billing_service: mock_billing_service
        )

        expect(oms.billing_service).to eq(mock_billing_service)
      end
    end
  end

  context "accept_order" do

    it "accepts the order" do
      expect(subject.accept_order(3)).to be_truthy
    end

  end
end
