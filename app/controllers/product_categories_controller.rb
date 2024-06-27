class ProductCategoriesController < ApplicationController
  helper_method :get_cart_order_products

  def index
    @product_category = ProductCategory.new
    @product = Product.new
    @product_categories

    if Rails.cache.fetch(:product_categories)
      @product_categories = Rails.cache.fetch(:product_categories)
    else
      Rails.cache.write(:product_categories, ProductCategory.all.order(name: :asc))
      @product_categories = Rails.cache.fetch(:product_categories)
    end

    if isAdmin
      redirect_to view_admin_home_path
    elsif current_user && current_user.id
      render 'index'
    else
      redirect_to view_welcome_path end
  end

  def search_product
    search_term = params[:search_term]
    puts search_term
    puts 'start'
    # @products = (Product.search query: { multi_match: { query: search_term, type: "phrase_prefix", fields: %w[name, description, price]} }).results
    @products = Product.search(search_term).results
    puts @products.to_json
    puts 'end'
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

  def edit_product_view
    @selected_product = Product.find(params[:product_id])
    @selected_product_category_name = params[:product_category_name]
    @product_categories = ProductCategory.all.order(name: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_product_category
    if isAdmin
      begin
        @product_category = ProductCategory.find(params[:product_category_id])
        @product_category.name = params[:menu_name]
        if @product_category.save
          flash[:notice] = 'Product category changes saved successfully!'
        else
          flash[:Error] = 'Error: Issue in creating the product category!'
        end
      rescue StandardError => e
        flash[:Error] = e.message
      end
      redirect_to view_home_path
    else
      render plain: 'Error: 404 Not Authorized'
    end
  end

  def destroy
    if isAdmin
      begin
        @product_category = ProductCategory.find(params[:product_category_id])
        if @product_category.destroy
          flash[:notice] = 'Product category deleted successfully!'
        else
          flash[:Error] = 'Error: Issue in deleting the product category!'
        end
      rescue StandardError => e
        flash[:Error] = e.message
      end
      redirect_to view_home_path
    else
      render plain: 'Error: 404 Not Authorized'
    end
  end

  def get_cart_order_products
    if current_user
      @get_cart_order_products = {}
      if get_cart_orders_current_user && get_cart_orders_current_user.first
        get_cart_orders_current_user.first.order_products.each do |order_item|
          @get_cart_order_products[order_item.product_id] = order_item.product_quantity
        end
      end
    end
    @get_cart_order_products
  end
end
