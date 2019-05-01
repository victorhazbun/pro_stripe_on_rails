module PaymentGatewayErrors
  class ServiceError < StandardError
    attr_reader :exception_message

    def initialize(message, exception_message: )
      # Call the parent's constructor to set the message
      super(message)

      # Set exception_message
      @exception_message = exception_message
    end
  end

  class CreateSubscriptionServiceError < ServiceError; end
  class CreatePlanServiceError < ServiceError; end
  class CreateCustomerServiceError < ServiceError; end
  class GetEventServiceError < ServiceError; end
  class GetPlanServiceError < ServiceError; end
  class StripeClientError < ServiceError; end
  class ClientError < ServiceError; end
end
