Rails.application.routes.draw do
  resources :contributions
  resources :users
  root 'contributions#index'
end