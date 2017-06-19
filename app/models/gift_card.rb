class GiftCard < ApplicationRecord
  has_many :transactions, inverse_of: :gift_card
  validates_numericality_of :balance, greater_than: 0
end
