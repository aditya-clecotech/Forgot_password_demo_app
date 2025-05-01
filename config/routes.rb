Rails.application.routes.draw do

  root "users#index"
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create]
  delete "/session", to: "sessions#destroy"

  # password reset functionality routes: 
  get '/password/reset', to: 'password_resets#new'
  post '/password/reset', to: 'password_resets#create'
  get '/password/reset/edit', to: 'password_resets#edit'
  patch '/password/reset/edit', to: 'password_resets#update'

end
