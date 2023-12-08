Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index]
      end
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create, :destroy]
      delete '/market_vendors', to: 'market_vendors#destroy'
      post '/market_vendors', to: 'market_vendors#create'
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
