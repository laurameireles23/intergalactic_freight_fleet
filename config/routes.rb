Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :pilots, only: [:create]
  post 'pilots/:id/travel', to: 'pilots#travel', as: 'pilot_travel'

  resources :resources, only: [:create]

  resources :contracts, only: [:create] do
    member do
      post 'accept_and_pay', to: 'contracts#accept_contract_and_pay_pilot'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
