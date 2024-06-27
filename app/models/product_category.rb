# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  has_many :products, class_name: 'Product', dependent: :destroy
end
