Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get "/user_questions", to: "questions#user_questions"
  get "/profile", to: "users#profile"
  post "/answers", to: "answers#create"

  get 'questions/:id/upvote', to: 'question_votes#upvote', as: 'question_upvote'
  get 'questions/:id/downvote', to: 'question_votes#downvote', as: 'question_downvote'
  get 'answers/:id/upvote', to: 'answer_votes#upvote', as: 'answer_upvote'
  get 'answers/:id/downvote', to: 'answer_votes#downvote', as: 'answer_downvote'

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
  root to: "questions#index"
  resources :users
  resources :questions
  resources :answers, except: [:show]
  resources :question_votes
  resources :answer_votes
end
