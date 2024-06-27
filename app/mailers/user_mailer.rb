# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_order_status_mail(params)
    @user = params[:user]
    @order_id = params[:order_id]
    @stage = params[:current_stage]
    Rails.logger.debug "--------------------#{@order_id}"
    Rails.logger.debug "--------------------#{@stage}"
    mail(to: @user.email, subject: 'Ecommerce! Order Update')
  end

  def send_order_create_mail(params)
    @user = params[:user]
    @order_id = params[:order_id]
    @stage = params[:current_stage]
    Rails.logger.debug "--------------------#{@order_id}"
    Rails.logger.debug "--------------------#{@stage}"
    mail(to: @user.email, subject: 'Ecommerce! Order Placed')
  end
end
