class GiftCardsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def index
    @gift_cards = GiftCard.where("card_number like ?", "%#{params[:search]}%").order(sort_column + " " + sort_direction).page(params[:page])
    @gift_card_audits = Audited::Audit.where(action: 'update', auditable_type: 'GiftCard', user_id: 1).order('created_at desc')
  end

  def validate
    @gift_card = GiftCard.find_by_card_number_and_pin(params[:card_number], params[:pin])
    if @gift_card.present?
      redirect_to gift_card_path(id: encrypt_data(@gift_card.id))
    else
      redirect_to root_path, alert: "Invalid Gift Card Credentials"
    end
  end

  def show
    @gift_card = GiftCard.find_by(id: decrypt_data(params[:id]))
    if @gift_card
      @transactions = @gift_card.transactions.order('created_at desc').limit(5)
    else
      redirect_to root_path, alert: "Invalid Card Details."
    end
  end

  def edit
    @gift_card = GiftCard.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @gift_card = GiftCard.find(params[:id])
    respond_to do |format|
      if @gift_card.update_attributes({balance: @gift_card.balance + params[:top_up].to_f, expiry: params[:gift_card][:expiry],audit_comment: params[:audit_comment]})
        format.html {redirect_to gift_cards_path(page: params[:page], search: params[:search], direction: params[:direction]), notice: "Top up successful"}
      else
        format.html { render :edit }
        format.js
        format.json { render json: @gift_card.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def encrypt_data(data)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    return crypt.encrypt_and_sign(data)
  end

  def decrypt_data(data)
     crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
     return crypt.decrypt_and_verify(data)
  end

  def sort_column
    GiftCard.column_names.include?(params[:sort]) ? params[:sort] : "expiry"
  end

end
