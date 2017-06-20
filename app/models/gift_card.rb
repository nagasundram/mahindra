class GiftCard < ApplicationRecord
  audited
  has_many :transactions, inverse_of: :gift_card
  validates_numericality_of :balance, greater_than: 0
  validates :card_number, uniqueness: { message: " already exists"}
end
