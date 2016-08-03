Rails.application.routes.draw do
  
  get 'rooms/show'

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do  
	  match '/users/sign_out' => 'devise/sessions#destroy', via: [:get, :post]
  end

  resources :users
  resources :blogs do
    collection do
      get :draft
    end
    resources :comments
  end

  authenticated :user do
    root 'blogs#index', as: :authenticated_root
  end

  mount ActionCable.server => '/cable'
  root 'welcome#index'
end
