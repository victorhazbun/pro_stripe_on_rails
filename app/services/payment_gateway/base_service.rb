module PaymentGateway
  class BaseService
    def self.client
      @client ||= PaymentGateway::Client.new
    end
  end
end