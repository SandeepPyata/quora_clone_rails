Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/myquestions", to: "homepage#myquestions"
  get "/profile", to: "homepage#profile"

  devise_scope :user do
    root to: "homepage#index"
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
 resources :users
 resources :questions
end
