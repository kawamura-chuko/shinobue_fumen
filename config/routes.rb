Rails.application.routes.draw do
  root 'sheets#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create]
  resources :sheets do
    resources :comments, only: %i[create destroy edit update], shallow: true
    collection do
      get :search
    end
  end
  resource :profile, only: %i[show edit update]

  namespace :admin do
    get 'comments/index'
    get 'comments/edit'
    get 'comments/show'
    get 'sheets/index'
    get 'sheets/edit'
    get 'sheets/show'
    get 'users/index'
    get 'users/edit'
    get 'user_sessions/new'
    get 'dashboards/index'
    root to: 'dashboards#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :comments, only: %i[index edit update show destroy]
    resources :sheets, only: %i[index edit update show destroy]
    resources :users, only: %i[index edit update show destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
