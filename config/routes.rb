Rails.application.routes.draw do
  root 'users#index'
  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new'
  get ':id', to: 'contributions#newest'
  put ':id', to: 'contributions#like'
  
  
  
  resources :contributions, :path => "/"
  resources :users
  
  
end