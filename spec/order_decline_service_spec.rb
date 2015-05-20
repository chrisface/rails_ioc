require 'rails_helper'

describe OrderDeclineService do
  subject { OrderDeclineService.build(param_1: param_1) }

  let(:param_1) { 1 }

  context ".build" do
    it "can be instantiated" do
      expect(subject.class).to eq(OrderDeclineService)
    end

    it "can receive parameters" do
      expect(subject.param_1).to eq(param_1)
    end

    context "dependency injection!" do
      let(:mock_billing_service) { { hehe: 'lol' } }

      it "blows up when given a stupid billing service" do
        oms = OrderDeclineService.build(
          param_1: param_1,
          billing_service: mock_billing_service
        )

        expect(oms.billing_service).to eq(mock_billing_service)
        expect { oms.decline_order }.to raise_exception
      end
    end
  end

  context "decline_order" do

    it "declines the order" do
      expect(subject.decline_order(3)).to be_truthy
    end

  end
end
