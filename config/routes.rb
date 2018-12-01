Rails.application.routes.draw do
  get 'profile/edit'
  post 'profile', to: 'profile#update'
  get 'user_files/new'
  get 'user_files/index'
  get 'user_files/:id', to: 'user_files#show', as: :user_files_show
  post 'user_files', to: 'user_files#create'
  resources :file_adapters
  devise_for :users
  resources :users
  get 'home/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
end
