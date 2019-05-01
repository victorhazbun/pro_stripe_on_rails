require 'payment_gateway/service_error'

module PaymentGateway
  class CreatePlanService < BaseService
    EXCEPTION_MESSAGE = 'There was an error while creating the plan'.freeze

    attr_accessor :payment_gateway_plan_identifier, :name,
      :price_cents, :interval

    def initialize(payment_gateway_plan_identifier:, name:,
        price_cents:, interval:)
      @payment_gateway_plan_identifier = payment_gateway_plan_identifier
      @name = name
      @price_cents = price_cents
      @interval = interval
    end

    def execute
      begin
        Plan.transaction do
          create_client_plan
          create_plan
        end
      rescue ActiveRecord::RecordInvalid, PaymentGateway::ClientError => e
        raise PaymentGateway::CreatePlanServiceError.new(EXCEPTION_MESSAGE,
          exception_message: e.message)
      end
    end

    private def create_client_plan
      client.create_plan!(
        name,
        id: payment_gateway_plan_identifier,
        amount: price_cents,
        currency: 'usd',
        interval: interval)
    end

    private def create_plan
      Plan.create!(
        payment_gateway_plan_identifier: payment_gateway_plan_identifier,
        name: name,
        price_cents: price_cents,
        interval: interval,
        status: :active)
    end
  end
end