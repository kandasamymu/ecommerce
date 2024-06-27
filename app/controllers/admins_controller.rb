# frozen_string_literal: true

# Controller responsible for managing administrative tasks and settings.

class AdminsController < ApplicationController
  def index
    @users = User.where(role: 'customer')
    'index'
  end
end
