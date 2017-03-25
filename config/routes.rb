Rails.application.routes.draw do

  resources :users

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'settings' }


  root to: 'users#index'
end
