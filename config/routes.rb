Rails.application.routes.draw do
  
  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new'
  get ':id', to: 'contributions#newest'
  put ':id', to: 'contributions#like'
  put 'newest/:id', to: 'contributions#like_from_newest'

  
  
  resources :contributions, :path => "/"
  resources :users
  
  root 'contributions#index'
end