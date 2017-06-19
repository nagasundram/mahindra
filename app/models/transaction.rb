class Transaction < ApplicationRecord
  audited
  belongs_to :user, inverse_of: :transactions
  belongs_to :gift_card, inverse_of: :transactions
  validates :invoice_number, presence: true
  validates :redeemed_value, presence: true
  validates_numericality_of :redeemed_value, greater_than: 0
  validates_numericality_of :current_balance, greater_than: 0

  after_create :update_card_balance

  def update_card_balance
    self.gift_card.update_attributes({balance: (self.gift_card.balance - self.redeemed_value)})
  end

end
