require 'payment_gateway/service_error'
class SubscriptionsController < ApplicationController
  rescue_from PaymentGateway::CreateSubscriptionServiceError do |e|
    redirect_to root_path, alert: e.message
  end

  before_action :load_plan

  def new
    @subscription = Subscription.new
  end

  def show
    @subscription = current_user.subscriptions.find(params[:id])
  end

  def create
    service = PaymentGateway::CreateSubscriptionService.new(
      user: current_user,
      plan: @plan,
      token: params[:payment_gateway_token])
    if service.execute && service.success
      redirect_to plan_subscription_path(@plan,
        service.subscription),
        notice: "Your subscription has been created."
    else
      render :new
    end
  end

  private

  def load_plan
    @plan = Plan.find(params[:plan_id])
  end
end