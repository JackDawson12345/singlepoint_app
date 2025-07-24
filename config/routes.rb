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

    resource :account_setup, controller: 'manage/account_setup', only: [:show, :update] do
      member do
        post :process_payment
        get :payment_success
        get :payment_failed
        get :confirmation
      end
    end
  end

  root 'main#home'
end