Rails.application.routes.draw do
  devise_for :users

  resources :plans, only: [:index] do
    resources :subscriptions, only: [:new, :create]
  end

  mount StripeEvent::Engine, at: '/stripe_events'

  root to: "pages#index"
end
