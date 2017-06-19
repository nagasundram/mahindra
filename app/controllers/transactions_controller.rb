class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search].present?
      @transactions = Transaction.joins(:user,:gift_card).where("users.store_code like ? or gift_cards.card_number like ? or invoice_number like ?", "%#{params[:search]}%","%#{params[:search]}%", "%#{params[:search]}%").order('created_at desc').page(params[:page])
    else
      @transactions = current_user.transactions.all.order('created_at desc').page(params[:page])
    end
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    @transaction.current_balance = @transaction.gift_card.balance - @transaction.redeemed_value
    if @transaction.save
      redirect_to root_path, notice: "Redemption successful"
    else
      redirect_to gift_card_path(id: @transaction.gift_card.id, card_number: @transaction.gift_card.card_number), alert: @transaction.errors.full_messages[0]
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:gift_card_id, :invoice_number, :redeemed_value)
  end

end
