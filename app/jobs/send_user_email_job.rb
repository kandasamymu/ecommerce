# frozen_string_literal: true

class SendUserEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, stage, order_id)
    Rails.logger.debug 'JOB Async - =================='
    user = User.find(user_id)
    if stage == 'Ordered'
      UserMailer.send_order_create_mail(user: user, current_stage: stage, order_id: order_id).deliver_now
    else
      UserMailer.send_order_status_mail(user: user, current_stage: stage, order_id: order_id).deliver_now
    end
  end
end
