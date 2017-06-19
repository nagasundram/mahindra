class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.all
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    if (@transaction.gift_card.balance.to_i) < (@transaction.redeemed_value.to_i)
       redirect_to gift_card_path(id: @transaction.gift_card, card_number: @transaction.gift_card.card_number), alert: 'Redemption should be less than or equal to card balance.'
     end
    @transaction.current_balance = @transaction.gift_card.balance - @transaction.redeemed_value
    if @transaction.save
      redirect_to root_path, notice: "Redemption successful"
    else
      redirect_to gift_card_path(id: @transaction.gift_card, card_number: @transaction.gift_card.card_number), alert: @transaction.errors.full_messages[0]
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:gift_card_id, :invoice_number, :redeemed_value)
  end

end
