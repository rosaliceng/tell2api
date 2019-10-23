Rails.application.routes.draw do
  post '/auth/login', to: 'authentications#login'

  namespace :api do
    namespace :v1 do
      resources :users
      get '/current_user', to: 'users#current'
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
