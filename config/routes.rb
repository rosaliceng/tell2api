Rails.application.routes.draw do
  post '/auth/login', to: 'authentications#login'

  namespace :api do
    namespace :v1 do
      # asldaskdj
      resources :users
      resources :places#, only: [:create,:update,:destroy]
      resources :share_withs
      get '/places', to: 'places#index'
      get '/current_user', to: 'users#current'
      post '/search_user/' => 'users#searchUserByEmail'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
