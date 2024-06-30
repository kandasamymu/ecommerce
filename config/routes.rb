# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  mount Sidekiq::Web => '/sidekiq'
  # sign/signout routes
  resources :sessions do
    collection do
      get '', to: 'user_sessions#new', as: :view_login
      post 'login', to: 'user_sessions#create', as: :request_login
      delete 'logout', to: 'user_sessions#destroy', as: :request_logout
      # get 'logout', to: 'user_sessions#destroy', as: :request_logout
    end
  end

  # register routes
  resources :users do
    collection do
      get 'register', to: 'users#index', as: :view_register
      post 'register', to: 'users#create', as: :request_register
    end
  end

  # order items routes
  resources :orders do
    collection do
      get '', to: 'orders#index', as: :view
      get 'open', to: 'orders#view_admin_open_orders', as: :view_admin_open
      post 'item/new', to: 'orders#create', as: :request_create
    end

    member do
      put 'change/stage', to: 'orders#change_order_status', as: :request_change_stage
    end
  end

  # home routes
  root to: 'home#index', as: :view_welcome
  get 'product' => 'product_categories#index', as: :view_home
  get 'admin/home' => 'admins#index', as: :view_admin_home

  # Product Item Routes have view and request
  get 'product/new/view' => 'product_categories#create_product_view', as: :view_create_product
  post 'product/edit/view' => 'product_categories#edit_product_view', as: :view_edit_product
  post 'product/new' => 'products#create', as: :request_create_product
  post 'product/update' => 'products#update_product', as: :request_edit_product

  put 'products/search' => 'product_categories#search_product', as: :request_search_product
  get 'products' => 'products#index', as: :view_products
  post 'product/category/edit' => 'product_categories#edit_product_category', as: :request_edit_product_category
  delete 'product/category/delete' => 'product_categories#destroy', as: :request_delete_product_category
  delete 'product/delete' => 'products#delete_product', as: :request_delete_product


  # check out routes
  get 'checkout/view' => 'check_out#index', as: :view_check_out
  post 'order/place' => 'check_out#place_order', as: :request_change_order_status

  # Email Routes

  get 'send/email' => 'admins#email_sender', as: :request_send_email_to_user
end
