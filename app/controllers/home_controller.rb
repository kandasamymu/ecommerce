class HomeController < ApplicationController
  def index
    if current_user && current_user.id
      redirect_to view_home_path
    else
      render 'index'
    end
  end
end
