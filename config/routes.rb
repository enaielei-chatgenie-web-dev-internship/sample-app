Rails.application.routes.draw do
  root("sessions#new")

  get("/about", to: "static_pages#about")
  get("/:id/profile", to: "users#show", as: "user")

  get("/auth/sign-up", to: "users#new")
  post("/auth/sign-up", to: "users#create")

  get("/auth", to: "sessions#new")
  get("/auth/sign-in", to: "sessions#new")
  post("/auth/sign-in", to: "sessions#create")

  delete("/auth/sign-out", to: "sessions#destroy")

  get("/:id/settings", to: "users#edit", as: "edit_user")
  patch("/:id/settings", to: "users#update")

  get("/users", to: "users#index", as: "users")
  delete("/:id/delete", to: "users#destroy", as: "delete_user")

  resources(:account_activations, only: [:edit])

  resources(:password_resets, only: [:new, :create, :edit, :update])

  # delete("/")

  # resources(:users)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
