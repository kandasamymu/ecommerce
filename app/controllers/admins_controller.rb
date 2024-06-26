class AdminsController < ApplicationController
  def index
    @users = User.where(:role => "customer")
    "index"
  end
end
