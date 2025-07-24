Rails.application.routes.draw do

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    sessions: 'users/sessions'
  }

  namespace :manage do
    get "domains/index"
    get "panel/index"
  end
  namespace :admin do
    get "dashboard/index"
  end
  get "main/home"
  constraints subdomain: 'admin' do
    get '/', to: 'admin/dashboard#index'
  end

  constraints subdomain: 'manage' do
    get '/', to: 'manage/panel#index', as: :manage_root

    get '/domain', to: 'manage/domains#index', as: :domain_root


  end

  root 'main#home'
end
