require 'payment_gateway_errors/service_error'

module PaymentGateway
  class GetPlanService < BaseService
    ERROR_MESSAGE = 'There was an error while retreiving the plan'.freeze

    def self.execute(payment_gateway_plan_identifier: )
      begin
        client.lookup_plan(identifier: payment_gateway_plan_identifier)
      rescue PaymentGatewayErrors::ClientError => e
        raise PaymentGatewayErrors::GetPlanServiceError.new(ERROR_MESSAGE, exception_message: e.message)
      end
    end
  end
end