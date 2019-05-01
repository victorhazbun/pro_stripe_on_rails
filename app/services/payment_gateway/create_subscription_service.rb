require 'payment_gateway_errors/service_error'

module PaymentGateway
  class CreateSubscriptionService < BaseService
    ERROR_MESSAGE = 'There was an error while creating the subscription'.freeze

    def self.execute(user:, plan:, source:)
      begin
        ActiveRecord::Base.transaction do
          customer = create_client_customer(source, user)
          create_client_subscription(customer, plan)

          update_user(user, customer)
          create_subscription(user, plan)
        end
      rescue PaymentGatewayErrors::CreateCustomerServiceError,
        PaymentGatewayErrors::GetPlanServiceError,
        PaymentGatewayErrors::ClientError => e
        raise PaymentGatewayErrors::CreateSubscriptionServiceError.new(
          ERROR_MESSAGE,
          exception_message: e.message)
      end
    end

    def self.create_client_customer(source, user)
      client.create_customer!(source: source, email: user&.email)
    end

    def self.create_client_subscription(customer, plan)
      client.create_subscription!(
        customer: customer,
        plan: PaymentGateway::GetPlanService.execute(
          payment_gateway_plan_identifier: plan.payment_gateway_plan_identifier
        )
      )
    end

    def self.create_subscription(user, plan)
      today = Date.current
      Subscription.create!(
        user: user,
        plan: plan,
        start_date: today,
        end_date: plan.end_date_from(today),
        status: :active
      )
    end

    def self.update_user(user, customer)
      user.update!(payment_gateway_customer_identifier: customer.id)
    end
  end
end