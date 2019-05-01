require 'payment_gateway_errors/service_error'

module PaymentGateway
  class StripeClient
    def lookup_customer(identifier:)
      handle_client_error do
        @lookup_customer ||= Stripe::Customer.retrieve(identifier)
      end
    end

    def lookup_plan(identifier:)
      handle_client_error do
        @lookup_plan ||= Stripe::Plan.retrieve(identifier)
      end
    end

    def lookup_event(identifier:)
      handle_client_error do
        @lookup_event ||= Stripe::Event.retrieve(identifier)
      end
    end

    def create_customer!(source:, email:)
      handle_client_error do
        Stripe::Customer.create(
          source: source,
          email: email
        )
      end
    end

    def create_plan!(currency:, interval:, product_name:, id:, amount:)
      handle_client_error do
        Stripe::Plan.create(
          id: id,
          amount: amount,
          currency: currency,
          interval: interval,
          product: {
            name: product_name
          }
        )
      end
    end

    def create_subscription!(customer:, plan:)
      Stripe::Subscription.create(
        customer: customer.id,
        items: [
          plan: plan.id
        ]
      )
    end

    private def handle_client_error(message = nil, &block)
      begin
        yield
      rescue Stripe::StripeError => e
        raise PaymentGatewayErrors::StripeClientError.new(e.message, exception_message: e.message)
      end
    end
  end
end