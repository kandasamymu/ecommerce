class UsersController < ApplicationController
  def index
    if isAdmin || !current_user
      @user = User.new
      render 'index'
    else
      redirect_to view_home_path end
  end

  def create
    puts '1111'
    puts user_params
    @user = User.new(user_params)
    @user.role = $USER_TYPE_ADMIN

    @user.role = if user_params[:role] == $USER_TYPE_ADMIN
                   user_params[:role]
                 else
                   $USER_TYPE_CUSTOMER
                 end

    if @user.save
      flash[:notice] = 'User has been created successfully!'
      redirect_to view_login_path
    else
      render action: :index
    end
  end

  private

  # def user_params
  #   params.permit(:first_name, :last_name, :email, :password, :role, :password_confirmation, :persistence_token)
  #   # params.permit(:first_name, :last_name, :email, :password, :role, :password_confirmation)
  # end
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role,
                                 :persistence_token)
  end
end
