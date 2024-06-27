require 'sidekiq/web'
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  mount Sidekiq::Web => '/sidekiq'
  # resources :users
  # sign/signout routes
  get 'sessions' => 'user_sessions#new', as: :view_login
  post 'sessions/login' => 'user_sessions#create', as: :request_login
  delete 'sessions/logout' => 'user_sessions#destroy', as: :request_logout

  # register routes
  get 'user/register' => 'users#index', as: :view_register
  # get "user" => "users#index", as: :view_register2
  post 'user/register' => 'users#create', as: :request_register

  # home routes
  root to: 'home#index', as: :view_welcome
  get 'product' => 'product_categories#index', as: :view_home
  get 'admin/home' => 'admins#index', as: :view_admin_home

  # Product Item Routes have view and request
  get 'product/new/view' => 'product_categories#create_product_view', as: :view_create_product
  post 'product/edit/view' => 'product_categories#edit_product_view', as: :view_edit_product
  post 'product/new' => 'products#create', as: :request_create_product
  post 'product/update' => 'products#update_product', as: :request_edit_product

  put 'product/search' => 'product_categories#search_product', as: :request_search_product
  post 'product/category/edit' => 'product_categories#edit_product_category', as: :request_edit_product_category
  delete 'product/category/delete' => 'product_categories#destroy', as: :request_delete_product_category
  delete 'product/delete' => 'products#delete_product', as: :request_delete_product

  # order items routes
  get 'orders' => 'orders#index', as: :view_orders
  get 'orders/open' => 'orders#view_admin_open_orders', as: :view_admin_open_orders
  put 'orders/change/stage' => 'orders#change_order_status', as: :request_change_order_stage
  post 'order/item/new' => 'orders#create_order', as: :request_create_order_product

  # check out routes
  get 'checkout/view' => 'check_out#index', as: :view_check_out
  post 'order/place' => 'check_out#place_order', as: :request_change_order_status

  # Email Routes

  get 'send/email' => 'admins#email_sender', as: :request_send_email_to_user
end
