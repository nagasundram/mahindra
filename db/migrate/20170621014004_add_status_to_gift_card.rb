class AddStatusToGiftCard < ActiveRecord::Migration[5.1]
  def change
    add_column :gift_cards, :status, :boolean, :default => "1"
  end
end
