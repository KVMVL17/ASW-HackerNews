Rails.application.routes.draw do
  
  get 'newest', to: 'contributions#index'
  get 'submit', to: 'contributions#new'
  
  resources :contributions, :path => "/"
  resources :users
  
  root 'contributions#index'
end