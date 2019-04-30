class AddPaymentGatewayCustomerIdentifierToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :payment_gateway_customer_identifier, :string
  end
end
