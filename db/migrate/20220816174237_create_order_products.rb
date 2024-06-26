class CreateOrderProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :order_products do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :product_name, null: false
      t.decimal :product_price, null: false
      t.integer :product_quantity, default: 1
    end
  end
end
