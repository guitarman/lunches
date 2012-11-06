Lunches::Application.routes.draw do
  get "lunch/index"
  root :to => "lunch#index"

  match ':controller(/:action(/:id(.format)))'
end
