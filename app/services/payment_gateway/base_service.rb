module PaymentGateway
  class BaseService
    protected def client
      @client ||= PaymentGateway::Client.new
    end
  end
end