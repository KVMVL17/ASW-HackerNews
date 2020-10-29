Rails.application.routes.draw do
  
  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new'
  get ':id', to: 'contributions#newest'
  
  resources :contributions, :path => "/"
  resources :users
  
  root 'contributions#index'
end