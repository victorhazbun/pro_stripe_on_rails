class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.jsonb :payment_gateway_event_data

      t.timestamps
    end
  end
end
