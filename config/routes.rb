Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/user_questions", to: "questions#user_questions"
  get "/profile", to: "users#profile"

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
  root to: "questions#index"
  resources :users
  resources :questions do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  resources :answers, except: [:show] do
    member do
      get 'upvote'
      get 'downvote'
    end
  end
end
