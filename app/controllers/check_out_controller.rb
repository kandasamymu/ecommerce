# frozen_string_literal: true

class CheckOutController < ApplicationController
  helper_method :get_cart_order_products_with_calculated_price

  def index
    get_cart_order_products_with_calculated_price
    'index'
  end

  def place_order
    order_id = params[:order_id]
    begin
      order = Order.find(order_id)
      if order
        order.order_status = $ORDER_STAGES[1]
        order.order_placed_date = Date.today
        if !order.save
          flash[:Error] = 'Error: Not able to place the order.. Please try again!'
        else
          SendUserEmailJob.perform_later(order.user_id, order.order_status, order_id)
          flash[:notice] = 'Your order has been successfully Placed!!'
        end
      end
    rescue StandardError => e
      flash[:Error] = e.message
    end

    redirect_to view_orders_path
  end

  def get_cart_order_products_with_calculated_price
    if current_user
      @get_cart_order_products_with_calculated_price = { 'total_price' => 0, 'order_products' => [] }
      if get_cart_orders_current_user&.first
        get_cart_orders_current_user.first.order_products.each do |order_product|
          @get_cart_order_products_with_calculated_price['order_products'].push(order_product)
          @get_cart_order_products_with_calculated_price['total_price'] =
            @get_cart_order_products_with_calculated_price['total_price'] + (order_product.product_price * order_product.product_quantity)
        end
      end
    end
  end
end
