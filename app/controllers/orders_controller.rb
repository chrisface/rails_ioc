class OrdersController < ApplicationController
  include InversionOfControl

  # We can still have our dependencies injected even if we're not in control
  # of instantiate of the object like this controller by calling .inject_services
  inject :order_acceptance_service
  before_action(:inject_services)

  def accept_order
    success = order_acceptance_service.accept_order(params[:id])
    render :nothing => true, status: success ? 200 : 400
  end

  def decline_order

    # We can still construct services using .build and keep DI
    # We can also override dependencies as well.
    order_decline_service = OrderDeclineService.build({
      param_1: "silly param",
      billing_service: SomeOtherPaymentImpl, #If the class has IOC support .build is called
      customer_contact_service: TwitterContactService.new # You can pass anything in really as a dependency
    })

    success = order_decline_service.decline_order(params[:id])
    render :nothing => true, status: success ? 200 : 400
  end
end
