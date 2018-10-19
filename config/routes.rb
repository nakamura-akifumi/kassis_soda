Rails.application.routes.draw do
  get 'user_files/new'
  get 'user_files/index'
  get 'user_files/show'
  post 'user_files', to: 'user_files#create'
  resources :file_adapters
  devise_for :users
  resources :users
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
