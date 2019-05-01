require 'payment_gateway_errors/service_error'

module PaymentGateway
  class GetEventService < BaseService
    ERROR_MESSAGE = 'There was an error while retreiving the event'.freeze

    def self.execute(payment_gateway_event_identifier: )
      begin
        client.lookup_event(identifier: payment_gateway_event_identifier)
      rescue PaymentGatewayErrors::ClientError => e
        raise PaymentGatewayErrors::GetEventServiceError.new(ERROR_MESSAGE, exception_message: e.message)
      end
    end
  end
end