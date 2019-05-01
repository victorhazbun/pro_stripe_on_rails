require 'payment_gateway/service_error'

namespace :plans do
  task create: :environment do
    plans = [
        {
          payment_gateway_plan_identifier: 'gold',
          name: 'Gold',
          price_cents: 30_000,
          interval: 'month'
        },
        {
          payment_gateway_plan_identifier: 'silver',
          name: 'Silver',
          price_cents: 20_000,
          interval: 'month'
        },
        {
          payment_gateway_plan_identifier: 'bronze',
          name: 'Bronze',
          price_cents: 10_000,
          interval: 'month'
        }
    ]
    Plan.transaction do
      begin
        plans.each do |plan|
          PaymentGateway::CreatePlanService.new(**plan).execute
        end
      rescue PaymentGateway::CreatePlanServiceError => e
        puts "Error message: #{e.message}"
        puts "Exception message: #{e.exception_message}"
      end
    end
  end
end