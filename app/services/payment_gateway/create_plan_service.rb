require 'payment_gateway_errors/service_error'

module PaymentGateway
  class CreatePlanService < BaseService
    DEFAULT_CURRENCY = 'usd'.freeze
    EXCEPTION_MESSAGE = 'There was an error while creating the plan'.freeze

    def self.execute(payment_gateway_plan_identifier:, name:,
        price_cents:, interval:, interval_count:)
      begin
        Plan.transaction do
          client.create_plan!(
            currency: DEFAULT_CURRENCY,
            product_name: name,
            id: payment_gateway_plan_identifier,
            amount: price_cents,
            interval: interval
          )
          Plan.create!(
            payment_gateway_plan_identifier: payment_gateway_plan_identifier,
            name: name,
            price_cents: price_cents,
            interval: interval,
            status: :active,
            interval_count: interval_count
          )
        end
      rescue ActiveRecord::RecordInvalid, PaymentGatewayErrors::ClientError => e
        raise PaymentGatewayErrors::CreatePlanServiceError.new(EXCEPTION_MESSAGE,
          exception_message: e.message)
      end
    end
  end
end