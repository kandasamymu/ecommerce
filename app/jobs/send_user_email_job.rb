
class SendUserEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, stage, order_id)
    puts "JOB ASYnc - ===-=-=---------============000================="
    # user = User.find(params[:user_id])
    # UserMailer.send_order_status_mail(user: user, current_stage: params[:stage], order_id: params[:order_id]).deliver_later
    user = User.find(user_id)
    # UserMailer.send_order_status_mail(user: user, current_stage: stage, order_id: order_id).deliver_now
    if stage == "Ordered"
      UserMailer.send_order_create_mail(user: user, current_stage: stage, order_id: order_id).deliver_now
    else
      UserMailer.send_order_status_mail(user: user, current_stage: stage, order_id: order_id).deliver_now
    end
  end
end
