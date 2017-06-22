Rails.application.routes.draw do
  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  devise_for :users
  resources :users

  resources :gift_cards do
    collection do
      get 'validate'
    end
  end

  resources :transactions do
    collection do
      get 'report'
      get 'audits'
    end
  end

end
