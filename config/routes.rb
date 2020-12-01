Rails.application.routes.draw do
  
  
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
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
    get 'userprofile', to: 'users#userprofile'
    get 'myprofile', to: 'users#myprofile'
    put 'updateprofile', to: 'users#updateprofile'
  end

  scope "/api",defaults: {format: 'json'} do
    #contributions
    get 'contributions', to: 'api/contributions#index', as: 'index_api'
    get 'newest', to: 'api/contributions#newest', as: 'newest_api'
    get 'ask', to: 'api/contributions#ask', as: 'ask_api'
    get 'contributions/users/:id', to: 'api/contributions#showcontributionsofuser', as: 'contributionsofuser_api'
    get 'contributions/:id', to: 'api/contributions#show', as: 'show_contribution_api'
    
    post 'contributions', to: 'api/contributions#create', as: 'contribution_create'
    delete 'contributions/:id', to: 'api/contributions#destroy', as: 'contribution_delete'
    
    #likes
    post '/contributions/:id/likes', to: 'api/contributions#like', as: 'like_api'
    delete '/contributions/:id/likes', to: 'api/contributions#dislike', as: 'dislike_api'
    
    get 'users/:id', to: 'api/users#show', as: 'show_user_api'
    put 'users/:id', to: 'api/users#updateprofile', as: 'updateUser'
    
    #comments & replies
    get 'contributions/:id/comments', to: 'api/contributions#showComments', as: 'comment_api'
    get 'comments/:id/replies', to: 'api/replies#show', as: 'replies_api'
  end

  get 'newest', to: 'contributions#newest', as: 'newest'
  get 'submit', to: 'contributions#new', as: 'submit'
  get 'ask', to: 'contributions#ask', as: 'ask'
  get 'threads/:id', to: 'contributions#threads', as: 'threads'
  get 'contributions/user/:id', to: 'contributions#showcontributionsofuser'
  get 'upvoted/submissions/:id', to: 'contributions#upvoted_submissions'
  get 'upvoted/comments/:id', to: 'contributions#upvoted_comments'
  

  put 'like/:id', to: 'contributions#like', as: 'like'
  put 'dislike/:id', to: 'contributions#dislike', as: 'dislike'
  put 'comments/like/:id', to: 'comments#like', as: 'like_comment'
  put 'comments/dislike/:id', to: 'comments#dislike', as: 'dislike_comment'
  put 'replies/like/:id', to: 'replies#like', as: 'like_reply'
  put 'replies/dislike/:id', to: 'replies#dislike', as: 'dislike_reply'

  resources :contributions, :path => "/"
  
  resources :users 
    
end