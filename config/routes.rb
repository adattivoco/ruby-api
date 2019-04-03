Rails.application.routes.draw do
  get    'health',               to: 'application#health'
  post   'auth',                 to: 'token#create'
  delete 'auth',                 to: 'token#destroy'
  post   'users/reset_password', to: 'users#send_reset'
  patch  'users/reset_password', to: 'users#attempt_reset'
  get    'purchase/token',       to: 'purchase#generate_payment_token'
  get    'products/summary',     to: 'products#summary_products'

  resources :users

  resources :products, only: [:index, :show, :create, :update] do
    member do
      get 'categories/products', to: 'products#categories_products'
    end
  end

  resources :categories, except: [:destroy] do
    member do
      get :products, to: 'categories#products'
    end
  end
end
