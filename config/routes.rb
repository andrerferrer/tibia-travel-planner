Rails.application.routes.draw do
  root to: "transportations#index"
  resources :transportations, only: :index
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
