# frozen_string_literal: true

class ProductCategoriesController < ApplicationController
  helper_method :get_cart_order_products

  def index
    @product_category = ProductCategory.new
    @product = Product.new
    @product_categories = Rails.cache.fetch(:product_categories) do
      ProductCategory.all.order(name: :asc)
    end

    if admin?
      redirect_to view_admin_home_path
    elsif current_user&.id
      render 'index'
    else
      redirect_to view_welcome_path
    end
  end

  def search_product
    search_term = params[:search_term]
    Rails.logger.debug search_term
    Rails.logger.debug 'start'
    # @products = (Product.search query: { multi_match: { query: search_term, type: "phrase_prefix", fields: %w[name, description, price]} }).results
    @products = Product.search(search_term).results
    Rails.logger.debug @products.to_json
    Rails.logger.debug 'end'
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create_product_view
    @product_categories = ProductCategory.all.order(name: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def get_cart_order_products
    if current_user
      @get_cart_order_products = {}
      if get_cart_orders_current_user&.first
        get_cart_orders_current_user.first.order_products.each do |order_item|
          @get_cart_order_products[order_item.product_id] = order_item.product_quantity
        end
      end
    end
    @get_cart_order_products
  end
end
