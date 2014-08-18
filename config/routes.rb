Rails.application.routes.draw do
  resources :ebooks, only: [:index, :new, :create, :destroy]
  root "ebooks#index"
end
