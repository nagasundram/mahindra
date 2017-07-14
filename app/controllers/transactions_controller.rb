class TransactionsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    authorize! :manage, Transaction
    @query = params[:search].downcase if params[:search].present?
    @transactions = Transaction.joins(:user,:gift_card).where("lower(users.store_code) like ? or invoice_number like ?", "%#{@query}%", "%#{@query}%").order(sort_column + " " + sort_direction).page(params[:page])
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
    @transaction = Transaction.new(transaction_params)
    if current_user.is_admin? && params[:store_code].present?
      @transaction.user = User.find_by(store_code: params[:store_code])
    else
      @transaction.user = current_user
    end
    @transaction.current_balance = @transaction.gift_card.balance - @transaction.redeemed_value
    respond_to do |format|
      if @transaction && @transaction.save
        @transaction.audits.first.update_attributes({comment: params[:comment]}) if current_user.is_admin?
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
        @gift_card = @transaction.gift_card
        @gift_card.balance = @transaction.current_balance
        @gift_card.save_without_auditing
        format.html {redirect_to transactions_path(page: params[:page], search: params[:search], direction: params[:direction]), notice: "Changes saved successfully"}
      else
        format.html { render :edit }
        format.js
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def report
    authorize! :read, Transaction
    @transactions = Transaction.where(updated_at: params[:start_date].to_date..(params[:end_date].to_date)+1.day)
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data @transactions.to_csv, filename: "Card Transaction as on #{params[:end_date].to_date.strftime("%d %B %Y")}.csv" }
    end
  end

  def audits
    authorize! :read, Transaction
    @audits = Audited::Audit.where(
                          action: 'update',
                          user_id: User.find_by_email(Rails.application.secrets.admin_email).id,
                          auditable_type: 'Transaction',
                          auditable_id: Transaction.where("invoice_number like ?", "%#{params[:search]}%").ids
                        ).order('created_at desc').page(params[:page])
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
