module PaymentGateway
  module Events
    class InvoicePaymentFailed
      def call(payment_gateway_event)
        create_event(get_payment_gateway_event(payment_gateway_event))
      end

      private def create_event(event)
        Event.create!(JSON.parse(event.to_json))
      end

      private def get_payment_gateway_event(payment_gateway_event)
        get_plan_service = PaymentGateway::GetEventService.new(payment_gateway_event.id)
        get_plan_service.execute
      end
    end
  end
end