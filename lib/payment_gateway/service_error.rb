module PaymentGateway
  class ServiceError < StandardError
    attr_reader :exception_message

    def initialize(message, exception_message: )
      # Call the parent's constructor to set the message
      super(message)

      # Set exception_message
      @exception_message = exception_message
    end
  end

  class CreateSubscriptionServiceError < PaymentGateway::ServiceError; end
  class CreatePlanServiceError < PaymentGateway::ServiceError; end
  class CreateCustomerServiceError < PaymentGateway::ServiceError; end
  class GetEventServiceError < PaymentGateway::ServiceError; end
  class StripeClientError < PaymentGateway::ServiceError; end
  class ClientError < PaymentGateway::ServiceError; end
end
