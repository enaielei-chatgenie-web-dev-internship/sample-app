Rails.application.routes.draw do
  root("sessions#new")
  get("/home", to: "static_pages#home")
  get("/about", to: "static_pages#about")
  get("/home/:id", to: "users#show", as: "user")

  get("/auth/sign-up", to: "users#new")
  post("/auth/sign-up", to: "users#create")

  get("/auth/sign-in", to: "sessions#new")
  post("/auth/sign-in", to: "sessions#create")

  delete("/auth/sign-out", to: "sessions#destroy")
  get("/auth", to: "sessions#new")

  # resources(:users)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
