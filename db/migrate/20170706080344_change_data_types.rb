class ChangeDataTypes < ActiveRecord::Migration[5.1]
  def change
    change_column :gift_cards, :balance, :float
    change_column :gift_cards, :activation_amount, :float
    change_column :gift_cards, :activation_amount, :float
    change_column :transactions, :redeemed_value, :float
  end
end
