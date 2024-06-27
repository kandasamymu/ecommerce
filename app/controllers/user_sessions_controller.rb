class UserSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    if current_user && current_user.id
      redirect_to view_home_path
    else
      @user_session = UserSession.new
      render 'new'
    end
  end

  def create
    return redirect_to view_home_path if current_user && current_user.id

    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      redirect_to view_home_path
    else
      render action: :new
    end
  end

  def destroy
    current_user_session.destroy
    Rails.cache.clear
    redirect_to view_welcome_path
  end

  private

  def user_session_params
    params.permit(:email, :password, :remember_me)
  end
end
