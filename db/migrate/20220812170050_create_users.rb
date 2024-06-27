# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name

      t.string :email, null: false
      t.string :crypted_password, null: false
      t.string :role, null: false

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
