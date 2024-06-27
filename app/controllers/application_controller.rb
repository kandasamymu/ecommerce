class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :set_locale
  protect_from_forgery with: :null_session
  $USER_TYPE_CUSTOMER = 'customer'
  $USER_TYPE_ADMIN = 'admin'

  $ORDER_STAGES = ['In Cart', 'Ordered', 'Shipped', 'OutForDelivery', 'Delivered', 'Cancelled']

  helper_method :current_user_session, :current_user, :isAdmin, :get_all_orders, :get_all_orders_current_user,
                :get_cart_orders_current_user

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)

    @current_user_session = UserSession.find
  end

  def isAdmin
    return @isAdmin if defined?(@isAdmin)

    @isAdmin = current_user if current_user && current_user.role == $USER_TYPE_ADMIN
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = current_user_session && current_user_session.user
  end

  def get_all_orders
    return @get_all_orders if defined?(@get_all_orders)

    if current_user && current_user.role == $USER_TYPE_ADMIN
      @get_all_orders = Order.order(order_placed_date: :desc).where.not(order_status: $ORDER_STAGES[0])
    end
  end

  def get_all_orders_current_user
    @get_all_orders_current_user = current_user.orders.order(order_placed_date: :desc) if current_user
  end

  def get_cart_orders_current_user
    @get_cart_orders_current_user = current_user.orders.where(order_placed_date: nil) if current_user
  end
end
