class AddStoreDetailsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :store_code, :string
    add_column :users, :store_name, :string
    add_column :users, :status, :string
    add_column :users, :region, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :pincode, :string
    add_column :users, :store_address, :string
  end
end
