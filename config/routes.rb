Lunches::Application.routes.draw do
  get "lunch/index"
  root :to => "lunch#index"

  resources :users
  resources :foods
  resources :soups


  match ':controller(/:action(/:id(.format)))'
end
