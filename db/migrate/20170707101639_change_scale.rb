class ChangeScale < ActiveRecord::Migration[5.1]
  def change
    change_column :gift_cards, :balance, :decimal, precision: 10, scale: 2
    change_column :gift_cards, :activation_amount, :decimal, precision: 10, scale: 2
    change_column :gift_cards, :activation_amount, :decimal, precision: 10, scale: 2
    change_column :transactions, :redeemed_value, :decimal, precision: 10, scale: 2
  end
end
