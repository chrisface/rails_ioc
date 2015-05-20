class OrderDeclineService
  include InversionOfControl

  # Look classes up by symbol name or provide alternate impl. can also be
  # overriden by .build
  inject({billing_service: SomeOtherPaymentImpl}, :customer_contact_service, :order_repository)

  attr_accessor :param_1, :param_2

  # initialize must use keyword arguments at the moment in order to determine
  # the difference between arguments that are injecting dependencies which get
  # stripped out before calling initialize.
  def initialize(param_1: )
    # For some arbitrary reason this service needs to have a param passed in
    self.param_1 = param_1
  end

  def decline_order(id)
    order = order_repository.find(id)

    return false unless order
    return false unless order.decline
    return false unless billing_service.capture_payment(order.total_cost)

    customer_contact_service.notify_customer(:order_declined)

    true
  end
end
