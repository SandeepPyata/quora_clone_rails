Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/userquestions", to: "questions#userquestions"
  get "/profile", to: "static_pages#profile"
  # get "/allquestions", to: "questions#allquestions"
  devise_scope :user do
    root to: "static_pages#index"
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
 resources :users
 resources :questions
end
