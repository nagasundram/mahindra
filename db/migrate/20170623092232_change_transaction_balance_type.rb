class ChangeTransactionBalanceType < ActiveRecord::Migration[5.1]
  def change
  	 change_column :transactions, :redeemed_value, :integer
  end
end
