class TransactionsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    authorize! :manage, Transaction
    @transactions = Transaction.joins(:user,:gift_card).where("users.store_code like ? or gift_cards.card_number like ? or invoice_number like ?", "%#{params[:search]}%","%#{params[:search]}%", "%#{params[:search]}%").order(sort_column + " " + sort_direction).page(params[:page])
  end

  def new
    @gift_card = GiftCard.find(decrypt_data(params[:id]))
    @transaction = Transaction.new
    respond_to do |format|
      format.html
      format.js
    end
  end


  def create
    authorize! :create, Transaction
    @transaction = current_user.transactions.new(transaction_params)
    @transaction.current_balance = @transaction.gift_card.balance - @transaction.redeemed_value
    respond_to do |format|
      if @transaction.save
        format.js {redirect_to gift_card_path(id:  encrypt_data(@transaction.gift_card.id) , card_number: @transaction.gift_card.card_number), notice: "Redemption successful"}
      else
        format.html { render :new }
        format.js
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @transaction = Transaction.find(params[:id])
    @gift_card = @transaction.gift_card
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    authorize! :update, Transaction
    @transaction = Transaction.find(params[:id])
    respond_to do |format|
      if @transaction.update_attributes(update_params)
        @transaction.gift_card.update_attributes(balance: @transaction.current_balance)
        format.html {redirect_to transactions_path(page: params[:page], search: params[:search], direction: params[:direction]), notice: "Transaction Updated successfully"}
      else
        format.html { render :edit }
        format.js
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def report
    authorize! :read, Transaction
    @transactions = Transaction.where(updated_at: params[:start_date].to_date..params[:end_date].to_date)
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data @transactions.to_csv }
    end
  end

  def audits
    authorize! :read, Transaction
    @audits = Audited::Audit.where(action: 'update', auditable_type: 'Transaction', user_id: 1).order('created_at desc')
  end

  private

  def transaction_params
    params.require(:transaction).permit(:gift_card_id, :invoice_number, :redeemed_value)
  end

  def update_params
    unless @transaction.redeemed_value.to_i == params[:transaction][:redeemed_value].to_i
      @redeem_difference = (@transaction.redeemed_value.to_i - params[:transaction][:redeemed_value].to_i).to_i.abs
      puts @redeem_difference
      return {
        invoice_number: params[:transaction][:invoice_number],
        redeemed_value: params[:transaction][:redeemed_value],
        audit_comment: params[:audit_comment],
        current_balance: (@transaction.redeemed_value.to_i > params[:transaction][:redeemed_value].to_i)? (@transaction.gift_card.balance + @redeem_difference) :(@transaction.gift_card.balance - @redeem_difference)
      }
    else
      return {
        invoice_number: params[:transaction][:invoice_number],
        audit_comment: params[:audit_comment]
      }
    end
  end

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

end
