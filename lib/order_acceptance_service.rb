class OrderAcceptanceService
  include InversionOfControl

  # Look classes up by symbol name or provide alternate impl. in constructor
  inject :billing_service, :customer_contact_service, :order_repository

  def accept_order(id)
    order = order_repository.find(id)

    return false unless order
    return false unless order.accept
    return false unless billing_service.capture_payment(order.total_cost)

    customer_contact_service.notify_customer(:order_accepted)

    true
  end
end
