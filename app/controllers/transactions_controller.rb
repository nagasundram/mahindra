class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search].present?
      @transactions = Transaction.joins(:user,:gift_card).where("users.store_code like ? or gift_cards.card_number like ? or invoice_number like ?", "%#{params[:search]}%","%#{params[:search]}%", "%#{params[:search]}%").order('created_at desc').page(params[:page])
    else
      @transactions = current_user.transactions.all.order('created_at desc').page(params[:page])
    end
  end

  def new
    @gift_card = GiftCard.find(params[:id])
    @transaction = Transaction.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  def create
    @transaction = current_user.transactions.new(transaction_params)
    @transaction.current_balance = @transaction.gift_card.balance - @transaction.redeemed_value
    respond_to do |format|
      if @transaction.save
        format.html {redirect_to root_path, notice: "Redemption successful"}
      else
        puts @transaction.errors.full_messages
        format.html { render :new }
        format.js
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:gift_card_id, :invoice_number, :redeemed_value)
  end

end
