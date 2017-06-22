class Transaction < ApplicationRecord
  audited
  belongs_to :user, inverse_of: :transactions
  belongs_to :gift_card, inverse_of: :transactions
  validates :invoice_number, presence: true
  validates :redeemed_value, presence: true
  validates_numericality_of :redeemed_value, greater_than: 0
  validates_numericality_of :current_balance, greater_than: 0, message: "^Redemption should be less than or equal to card balance"
  validates :invoice_number, uniqueness: { message: " already exists" }

  after_create :update_card_balance

  def update_card_balance
    self.gift_card.update_attributes({balance: (self.gift_card.balance - self.redeemed_value)})
  end

  def formatted_created_at
    created_at.strftime("%d/%m/%Y")
  end

   def self.to_csv
    CSV.generate do |csv|
      csv << [
        "Transaction Date",
        "Invoice Number",
        "Gift Card Number",
        "Store Code",
        "Store Name",
        "Gift Card Balance",
        "Amount Redeemed"]
      all.each do |transaction|
        csv << [
          transaction.formatted_created_at,
          transaction.invoice_number,
          transaction.gift_card.card_number,
          transaction.user.store_code,
          transaction.user.store_name,
          transaction.current_balance,
          transaction.redeemed_value
        ]
      end
    end
  end

end
