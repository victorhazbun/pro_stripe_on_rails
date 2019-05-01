require 'payment_gateway_errors/service_error'

namespace :plans do
  task create: :environment do
    plans = [
        {
          payment_gateway_plan_identifier: 'gold',
          name: 'Gold',
          price_cents: 30_000,
          interval: 'month',
          interval_count: '12'
        },
        {
          payment_gateway_plan_identifier: 'silver',
          name: 'Silver',
          price_cents: 20_000,
          interval: 'month',
          interval_count: '12'
        },
        {
          payment_gateway_plan_identifier: 'bronze',
          name: 'Bronze',
          price_cents: 10_000,
          interval: 'month',
          interval_count: '12'
        }
    ]
    Plan.transaction do
      begin
        plans.each do |plan|
          PaymentGateway::CreatePlanService.execute(**plan)
        end
      rescue PaymentGatewayErrors::CreatePlanServiceError => e
        puts "Error message: #{e.message}"
        puts "Exception message: #{e.exception_message}"
      end
    end
  end
end