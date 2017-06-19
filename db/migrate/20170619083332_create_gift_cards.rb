class CreateGiftCards < ActiveRecord::Migration[5.1]
  def change
    create_table :gift_cards do |t|
      t.string :card_number
      t.integer :pin
      t.float :balance
      t.datetime :expiry
      t.timestamps
    end
  end
end
