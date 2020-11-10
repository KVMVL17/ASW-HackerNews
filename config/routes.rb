Rails.application.routes.draw do
  
  
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  
  get 'login', to: 'users#new'
  post 'login', to: 'users#create'
  
  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new'
  get ':id', to: 'contributions#newest'
  put ':id', to: 'contributions#like'

  
  
  resources :contributions, :path => "/"
  resources :users
  
  root 'contributions#index'
end