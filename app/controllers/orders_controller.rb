# frozen_string_literal: true

class OrdersController < ApplicationController
  helper_method :get_enabled_stages

  def index
    @orders = get_all_orders_current_user
    'index'
  end

  def view_admin_open_orders
    @orders = get_all_orders
    render 'open_orders'
  end

  def create_order
    if params[:client_cart_products] != '' && params[:client_cart_products] != '{}'
      begin
        client_cart_products = ActiveSupport::JSON.decode(params[:client_cart_products])
        product_ids = client_cart_products.keys
        order_id = nil

        if get_cart_orders_current_user&.first
          order_id = get_cart_orders_current_user.first.id
        elsif current_user.orders.create(order_status: $ORDER_STAGES[0]) && get_cart_orders_current_user && get_cart_orders_current_user.first
          order_id = get_cart_orders_current_user.first.id
        end

        existing_order_products_to_be_deleted = []
        existing_order_products_to_be_updated = []
        OrderProduct.where(product_id: product_ids, order_id: order_id).each do |order_product|
          product_id = order_product.product_id.to_s
          product_ids.delete(product_id)

          if client_cart_products[product_id] && client_cart_products[product_id] != 0
            order_product.product_quantity = client_cart_products[product_id]
            existing_order_products_to_be_updated.push(order_product)
          elsif (client_cart_products[product_id]).zero?
            existing_order_products_to_be_deleted.push(order_product.id)
          end
        end

        if existing_order_products_to_be_deleted.count != 0 && !OrderProduct.destroy_all(id: existing_order_products_to_be_deleted)
          flash[:Error] = 'Error: In Deleted the Order Item'
        end

        if product_ids.count != 0 || existing_order_products_to_be_updated.count != 0
          products = product_ids.count != 0 ? Product.where(id: product_ids) : []

          unless order_id.nil?
            new_orders = products.map do |product|
              order_product = OrderProduct.new(
                order_id: order_id,
                product_name: product.name,
                product_id: product.id,
                product_price: product.price,
                product_quantity: client_cart_products[product.id.to_s]
              )
            end

            new_orders += existing_order_products_to_be_updated if existing_order_products_to_be_updated.count != 0
            save_failed = nil
            OrderProduct.transaction do
              new_orders.each do |order|
                unless order.save
                  save_failed = true
                  raise ActiveRecord::Rollback
                end
              end
            end
            flash[:Error] = 'Error: In Creating the Order Item' if save_failed
          end
        end
      rescue StandardError => e
        flash[:Error] = e.message
      end
    end
    redirect_to view_check_out_path
  end

  def get_enabled_stages(stage)
    enabled_stages = []
    flag = false
    $ORDER_STAGES.each do |curr_stage|
      enabled_stages.push([curr_stage, curr_stage]) if flag
      flag = true if curr_stage == stage
    end
    enabled_stages
  end

  def change_order_status
    order_id = params[:order_id]
    begin
      order = Order.find(order_id)
      if order
        order.order_status = params[:stage]
        if !order.save
          flash[:Error] = 'Error: Not able to update the order.. Please try again!'
        else
          SendUserEmailJob.perform_later(params[:user_id], params[:stage], order_id)
          flash[:notice] = 'Order Status has been successfully updated!'
        end
      end
    rescue StandardError => e
      flash[:Error] = e.message
    end

    redirect_to view_admin_open_orders_path
  end
end
