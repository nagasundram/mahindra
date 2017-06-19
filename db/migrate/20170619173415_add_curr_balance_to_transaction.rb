class AddCurrBalanceToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :current_balance, :float
  end
end
