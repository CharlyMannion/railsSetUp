Rails.application.routes.draw do
  root to: "posts#index"

  resources :posts, only: [:index, :new, :create, :destroy]

  resource :session, only: [:new, :create]
end


# Example of the config file used in the Todo app:

# Rails.application.routes.draw do
#   root to: "todos#index"
#
#   resources :todos, only: [:index, :new, :create] do
#     resource :completion, only: [:create, :destroy]
#   end
#
#   resource :session, only: [:new, :create]
# end
