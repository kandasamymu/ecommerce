# frozen_string_literal: true

class OrdersController < ApplicationController
  helper_method :get_next_stages

  def index
    @orders = get_all_orders_current_user
    'index'
  end

  def view_admin_open_orders
    @orders = get_all_orders
    render 'open_orders'
  end

  def create
    if params[:client_cart_products] != '' && params[:client_cart_products] != '{}'
      begin
        client_cart_products = ActiveSupport::JSON.decode(params[:client_cart_products])
        product_ids = client_cart_products.keys
        order_id = nil
        if get_cart_orders_current_user&.first
          order_id = get_cart_orders_current_user.first.id
          OrderProduct.where(order_id: order_id).destroy_all
        else
          current_user.orders.create(order_status: ORDER_STAGES[0])
          order_id = get_cart_orders_current_user.first.id
        end
        if product_ids.count.positive?
          products = Product.where(id: product_ids)
          unless order_id.nil?
            new_orders = products.map do |product|
              OrderProduct.new(
                order_id: order_id,
                product_name: product.name,
                product_id: product.id,
                product_price: product.price,
                product_quantity: client_cart_products[product.id.to_s]
              )
            end
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

  def get_next_stages(stage)
    next_stages = []
    flag = false
    ORDER_STAGES.each do |curr_stage|
      next_stages.push([curr_stage, curr_stage]) if flag
      flag = true if curr_stage == stage
    end
    next_stages
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
