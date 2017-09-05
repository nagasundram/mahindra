class Transaction < ApplicationRecord
  audited
  belongs_to :user, inverse_of: :transactions, optional: true
  belongs_to :gift_card, inverse_of: :transactions, optional: true
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
        "Gift Card Number",
        "Invoice Number",
        "Expiry Date",
        "Current Status",
        "Owning Store Code",
        "Owning Store Name",
        "Gift Card Activation Date",
        "Activation Amount",
        "Redeemed Store Code",
        "Redeemed Store Code",
        "Region",
        "City",
        "Amount Redeemed",
        "Gift Card Balance"
        ]
      all.each do |transaction|
        csv << [
          transaction.updated_at.strftime("%d/%m/%Y"),
          "'#{transaction.gift_card.card_number}",
          transaction.invoice_number,
          transaction.gift_card.expiry.strftime("%d/%m/%Y"),
          (transaction.gift_card.status)? "Active" : "Inactive",
          transaction.gift_card.owning_store_code,
          transaction.gift_card.owning_store_name,
          transaction.gift_card.activation_date.strftime("%d/%m/%Y"),
          transaction.gift_card.activation_amount,
          transaction.user.store_code,
          transaction.user.store_name,
          transaction.user.region,
          transaction.user.city,
          transaction.redeemed_value,
          transaction.current_balance
        ]
      end
    end
  end

end
