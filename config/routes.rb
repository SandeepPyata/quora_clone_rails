Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/myquestions", to: "questions#myquestions"
  get "/profile", to: "static_pages#profile"
  post "/answers", to: "answers#create"
  devise_scope :user do
    #root to: "static_pages#index"
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
  root to: "questions#index"
  resources :users
  resources :questions
  resources :answers, except: [:show]
end
