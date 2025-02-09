Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  post '/confirm_friendship', to: 'users#confirm_friendship'
  get '/reject_friendship/:id', to: 'users#reject_friendship', as: 'reject_friendship'

  resources :users, only: [:index, :show] do
    resources :friendships, only: [:create]
  end

  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
