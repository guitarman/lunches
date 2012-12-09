Lunches::Application.routes.draw do
  get "lunch/index"
  root :to => "lunch#index"

  resources :users
  resources :foods
  resources :soups
  resource :session

  match '/login' => "sessions#new", :as => "login"
  match '/logout' => "sessions#destroy", :as => "logout"

  match 'settings' => 'users#edit', :as => :settings, :via => :get

  match ':controller(/:action(/:id(.format)))'
end
