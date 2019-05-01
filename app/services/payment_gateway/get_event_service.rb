require 'payment_gateway/service_error'

module PaymentGateway
  class GetEventService < BaseService
    ERROR_MESSAGE = 'There was an error while retreiving the event'.freeze

    attr_accessor :payment_gateway_event_identifier

    def initialize(payment_gateway_event_identifier: )
      @payment_gateway_event_identifier = payment_gateway_event_identifier
    end

    def execute
      begin
        get_client_event
      rescue PaymentGateway::ClientError => e
        raise GetEventServiceError.new(ERROR_MESSAGE, exception_message: e.message)
      end
    end

    private def get_client_event
      client.lookup_plan(identifier: payment_gateway_event_identifier)
    end
  end
end