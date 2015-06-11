class OrdersController < ApplicationController
  include InversionOfControl

  inject :order_acceptance_service, :order_decline_service

  def accept_order
    success = order_acceptance_service.accept_order(params[:id])
    render :nothing => true, status: success ? 200 : 400
  end

  def decline_order
    success = order_decline_service.decline_order(params[:id])
    render :nothing => true, status: success ? 200 : 400
  end
end
