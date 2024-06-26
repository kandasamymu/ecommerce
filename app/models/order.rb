class Order < ApplicationRecord
  has_many :order_products, class_name: "OrderProduct", :dependent => :destroy
  belongs_to :user, class_name: "User", foreign_key: :user_id
end
