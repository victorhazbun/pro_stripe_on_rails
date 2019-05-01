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
        PaymentGateway::GetEventService.execute(payment_gateway_event_identifier: payment_gateway_event.id)
      end
    end
  end
end