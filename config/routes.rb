Rails.application.routes.draw do
  root("static_pages#home")
  get("/home", to: "static_pages#home")
  get("/about", to: "static_pages#about")
  get("/auth/sign-up", to: "users#new")
  get("/auth", to: "users#new")
  get("/home/:id", to: "users#show")
  # get("/auth/sign-in", to: "users#existing")
  resources(:users)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
