# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, unique: true, null: false
      t.references :product_category, null: false, foreign_key: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :description
    end
  end
end
