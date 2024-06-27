# frozen_string_literal: true

class OrderProduct < ApplicationRecord
  belongs_to :order, class_name: 'Order'
  belongs_to :product, class_name: 'Product'
  validates :order_id, presence: true
end
