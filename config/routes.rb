# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    sessions: 'users/sessions'
  }

  namespace :admin do
    get "dashboard/index"

    # Admin template management
    resources :templates do
      member do
        patch :toggle_active
      end
    end
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

    resources :website_builder, controller: 'manage/website_builder' do
      collection do
        get :choose_template
      end

      member do
        get :preview
        patch :publish
        patch :unpublish
        post :update_preview
      end
    end
  end

  root 'main#home'
end