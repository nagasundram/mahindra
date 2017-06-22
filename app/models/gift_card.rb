class GiftCard < ApplicationRecord
  audited
  has_many :transactions, inverse_of: :gift_card
  validates_numericality_of :balance, greater_than: 0
  validates :card_number, uniqueness: { message: " already exists"}
  validates :card_number, length: {is: 16, :message => "should be 16 characters"}
  validates :pin, length: {is: 6, :message => "should be 6 characters"}
  validates :expiry, presence: {message: " required"}


  scope :active_cards, -> { where(status: 1) }

  def formatted_expiry
    expiry.strftime("%d/%m/%Y")
  end
end
