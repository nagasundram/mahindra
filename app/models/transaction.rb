class Transaction < ApplicationRecord
  audited
  belongs_to :user, inverse_of: :transactions, optional: true
  belongs_to :gift_card, inverse_of: :transactions
  validates :user, presence: {message:"^Invalid Store Code"}
  validates :invoice_number, presence: true
  validates :redeemed_value, presence: true
  validates_numericality_of :redeemed_value, greater_than: 0
  validates_numericality_of :current_balance, greater_than_or_equal_to: 0, message: "^Redemption should be less than or equal to card balance"
  validates :invoice_number, uniqueness: { message: " already exists" }
  validates :invoice_number, length: {in: 1..30, :message => "should be between 1 to 30 characters"}


  after_create :update_card_balance

  def update_card_balance
    @gift_card = self.gift_card
    @gift_card.balance = self.gift_card.balance - self.redeemed_value
    @gift_card.save_without_auditing
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
