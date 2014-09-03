Rails.application.routes.draw do
  get 'welcome/index'

  get 'about' => 'ebooks#about', :as => 'about'
  get 'contact' => 'ebooks#contact', :as => 'contact'

	match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
	match 'auth/failure', to: redirect('/'), via: [:get, :post]
	match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
	
  get 'sessions/create'

  get 'sessions/destroy'

  resources :ebooks, only: [:index, :new, :create, :destroy, :show] do
    resources :pages
  end
  root "ebooks#new"
end
