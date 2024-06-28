# frozen_string_literal: true

# Controller responsible for managing administrative tasks and settings.

class AdminsController < ApplicationController
  def index
    @users = Rails.cache.fetch('customers', expires_in: 10.seconds) do
      User.where(role: 'customer')
    end
    'index'
  end
end
