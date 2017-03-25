Rails.application.routes.draw do
  get 'users/index'

  get 'users/show'

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'settings' }

  root to: 'users#index'
end
