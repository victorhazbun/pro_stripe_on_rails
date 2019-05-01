require 'payment_gateway_errors/service_error'

class SubscriptionsController < ApplicationController
  rescue_from PaymentGatewayErrors::CreateSubscriptionServiceError do |e|
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
    PaymentGateway::CreateSubscriptionService.execute(
      user: current_user,
      plan: @plan,
      source: params[:payment_gateway_token]
    )
    flash[:notice] = I18n.t('notice.subscription_created')
    redirect_to root_path
  end

  private

  def load_plan
    @plan = Plan.find(params[:plan_id])
  end
end