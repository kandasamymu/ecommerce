class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_salt, :string
    add_column :users, :persistence_token, :string
  end
end