Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # resources :pages do
  #   get :home
  # end
  # Defines the root path route ("/")
  # root "posts#index"
  resources :chats, only: [:index, :show, :create] do
    resources :messages, except: :show
  end

  resources :programs do
    resources :exercises, only: [:index, :show]
  end

  # resources :exercises, only: [] do
  #   resources :chats, only: [:create]
  # end

  resources :programs, only: [:destroy]
  resources :chats, only: [:destroy]


end
