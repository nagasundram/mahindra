class AddExtraColumnsToGiftCards < ActiveRecord::Migration[5.1]
  def change
    change_column :gift_cards, :balance, :integer
    add_column :gift_cards, :username, :string
    add_column :gift_cards, :activation_amount, :integer
    add_column :gift_cards, :activation_date, :datetime
  end
end
