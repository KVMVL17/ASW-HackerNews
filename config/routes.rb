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
    
    post 'contributions', to: 'api/contributions#create', as: 'contribution_create'
    get 'contributions/:id', to: 'api/contributions#show', as: 'show_contribution_api'
    delete 'contributions/:id', to: 'api/contributions#destroy', as: 'contribution_delete'
    put 'contributions/:id', to: 'api/contributions#update', as: 'contribution_update'
    
    #likes
    post '/contributions/:id/likes', to: 'api/contributions#like', as: 'like_api'
    delete '/contributions/:id/likes', to: 'api/contributions#dislike', as: 'dislike_api'
    
    get 'users/:id', to: 'api/users#show', as: 'show_user_api'
    put 'users/:id', to: 'api/users#updateprofile', as: 'updateUser'
    
    #comments
    get 'comments/upvoted', to: 'api/comments#upvoted_comments', as: 'upvoted_comments'
    get 'contributions/:id/comments', to: 'api/contributions#showComments', as: 'comment_api'
    post 'contributions/:id/comments', to: 'api/comments#create', as: 'comments_create'
    get 'comments/:id', to: 'api/comments#showComment', as: 'comment_show'
    delete 'comments/:id', to: 'api/comments#destroy', as: 'comment_delete'
    put 'comments/:id', to: 'api/comments#update', as: 'comment_update'
    post 'comments/:id/likes', to: 'api/comments#like', as: 'comment_like'
    delete 'comments/:id/likes', to: 'api/comments#dislike', as: 'comment_dislike'
    
    #replies
    get 'comments/:id/replies', to: 'api/replies#show', as: 'replies_api'
    post 'comments/:id/replies', to: 'api/replies#create', as: 'replies_create'
    get 'replies/:id', to: 'api/replies#showReply', as: 'reply_show'
    delete 'replies/:id', to: 'api/replies#destroy', as: 'reply_delete'
    put 'replies/:id', to: 'api/replies#update', as: 'reply_update'
    post 'replies/:id/likes', to: 'api/replies#like', as: 'reply_like'
    delete 'replies/:id/likes', to: 'api/replies#dislike', as: 'reply_dislike'
    post 'replies/:id', to: 'api/replies#create_recursive', as: 'reply_create_recursive'
    
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