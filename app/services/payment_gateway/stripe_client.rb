require 'payment_gateway/service_error'

module PaymentGateway
  class StripeClient
    def lookup_customer(identifier: )
      handle_client_error do
        @lookup_customer ||= Stripe::Customer.retreive(identifier)
      end
    end

    def lookup_plan(identifier: )
      handle_client_error do
        @lookup_plan ||= Stripe::Plan.retreive(identifier)
      end
    end

    def lookup_event(identifier: )
      handle_client_error do
        @lookup_event ||= Stripe::Event.retreive(identifier)
      end
    end

    def create_customer!(options={})
      handle_client_error do
        Stripe::Customer.create(email: options[:email])
      end
    end

    def create_plan!(product_name, options={})
      handle_client_error do
        Stripe::Plan.create(
          id: options[:id],
          amount: options[:amount],
          currency: options[:currency] || 'usd',
          interval: options[:interval] || 'month',
          product: {
            name: product_name
          }
        )
      end
    end

    def create_subscription!(customer: , plan: , source: )
      handle_client_error do
        customer.subscriptions.create(
          source: source,
          plan: plan.id
        )
      end
    end

    private def handle_client_error(message=nil, &block)
      begin
        yield
      rescue Stripe::StripeError => e
        raise PaymentGateway::StripeClientError.new(e.message, exception_message: e.message)
      end
    end
  end
end