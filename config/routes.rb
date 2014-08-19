Rails.application.routes.draw do
  resources :ebooks, only: [:index, :new, :create, :destroy, :show] do
    resources :pages
  end
  root "ebooks#index"
end
