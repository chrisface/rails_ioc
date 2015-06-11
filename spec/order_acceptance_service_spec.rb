require 'rails_helper'

describe OrderAcceptanceService do
  subject { OrderAcceptanceService.build }

  context "accept_order" do

    context "using the real dependencies" do
      it "accepts the order" do
        expect(subject.accept_order(3)).to be_truthy
      end
    end

    context "using alternate implementations" do
      class TestBillingService
        def capture_payment(amount)
          true
        end
      end

      class FakeContactService
        def notify_customer(message)
        end
      end

      class MemoryOrderRepository
        def find(id)
          Order.new
        end
      end

      before(:each) do
        InversionOfControl.register_dependency(:billing_service, TestBillingService)
        InversionOfControl.register_dependency(:customer_contact_service, FakeContactService)
        InversionOfControl.register_dependency(:order_repository, MemoryOrderRepository)
      end

      it "accepts the order" do
        expect(subject.accept_order(3)).to be_truthy
      end
    end

    context "using mock dependencies" do
      before(:each) do
        billing_service = double(capture_payment: true)
        contact_service = double(notify_customer: true)

        order = Order.new
        order_repository = double(find: order)

        billing_service_dependency = {instantiate: false, dependency: billing_service}
        contact_service_dependency = {instantiate: false, dependency: contact_service}
        order_repository_dependency = {instantiate: false, dependency: order_repository}

        InversionOfControl.register_dependency(:billing_service, billing_service_dependency)
        InversionOfControl.register_dependency(:customer_contact_service, contact_service_dependency)
        InversionOfControl.register_dependency(:order_repository, order_repository_dependency)
      end

      it "accepts the order" do
        expect(subject.accept_order(3)).to be_truthy
      end

    end

  end
end
