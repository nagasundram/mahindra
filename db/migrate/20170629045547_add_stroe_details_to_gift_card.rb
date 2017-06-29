class AddStroeDetailsToGiftCard < ActiveRecord::Migration[5.1]
  def change
    add_column :gift_cards, :owning_store_name, :string
    add_column :gift_cards, :owning_store_code, :string
  end
end
