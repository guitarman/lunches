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

  match 'lunch/add_soup/:name' => 'lunch#add_soup'
  match 'lunch/add_food/:name' => 'lunch#add_food'
  #match 'remove_favourite_soup' => 'lunch#remove_soup/:id', :as => :remove_favourite_soup

  match ':controller(/:action(/:id(.format)))'
end
