# frozen_string_literal: true

class ProductsController < ApplicationController

  def index
    @products = Product.all
    render "product_categories/_product_list"
  end

  def delete_product
    if admin?
      begin
        @product = Product.find(params[:product_id])
        # product_category_id = @product.product_category_id
        if @product.destroy
          flash[:notice] = 'Product Deleted successfully!'
        else
          flash[:Error] = 'Error: Issue in deleting the product!'
        end
      rescue StandardError => e
        flash[:Error] = e.message
        redirect_to view_home_path
      end
      redirect_to view_products_path
    else
      render plain: 'Error: Not Authorized'
    end
  end

  def create
    if admin?
      begin
        product_category_id = params[:product_category_id]
        Rails.logger.debug product_category_id
        if product_category_id == 'Others'
          @product_category = ProductCategory.new(name: params[:new_product_category_name])
          unless @product_category.save
            flash[:Error] = 'Error: Issue in creating the product category!'
            redirect_to view_home_path
          end
        else
          @product_category = ProductCategory.find(product_category_id)
        end

        if @product_category&.id
          @product = @product_category.products.new(name: params[:name], price: params[:price],
                                                    description: params[:description])
          if @product.save
            flash[:notice] = 'Products changes saved successfully!'
          else
            flash[:Error] = 'Error: Product Category Not Found!'
          end
        else
          flash[:Error] = 'Error: Product Category Not Found!'
        end
      rescue StandardError => e
        flash[:Error] = e.message
      end
      redirect_to view_home_path
    else
      render plain: 'Error: Not Authorized'
    end
  end
end
