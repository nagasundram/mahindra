class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.belongs_to :gift_card
      t.string :invoice_number
      t.float :redeemed_value
      t.timestamps
    end
  end
end
