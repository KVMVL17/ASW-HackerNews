Rails.application.routes.draw do
  
  
  resources :replies do
    member do
      post 'replyrecursive'
    end
  end
  
  resources :comments
  
  root 'contributions#index'
  
  post 'add_comment', to: 'comments#create', as: 'add_comment'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end
  
  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new', as: 'submit'
  put 'like/:id', to: 'contributions#like', as: 'like'
  put 'dislike/:id', to: 'contributions#dislike', as: 'dislike'

  resources :contributions, :path => "/"
  resources :users
  
end