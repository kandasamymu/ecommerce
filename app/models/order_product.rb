class OrderProduct < ApplicationRecord
  belongs_to :order, class_name: "Order", foreign_key: :order_id
  belongs_to :product, class_name: "Product", foreign_key: :product_id
  validates :order_id, presence: true
end