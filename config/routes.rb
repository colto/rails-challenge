Rails.application.routes.draw do

  resources :users do
    post 'add_friend', as: :add_friend
  end

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'settings' }

  root to: 'users#index'


end
