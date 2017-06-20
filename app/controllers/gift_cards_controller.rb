class GiftCardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @gift_cards = GiftCards.all
  end

  def validate
    @gift_card = GiftCard.find_by_card_number_and_pin(params[:card_number], params[:pin])
    if @gift_card.present?
      redirect_to gift_card_path(id: @gift_card.id, card_number: @gift_card.card_number)
    else
      redirect_to root_path, alert: "Invalid Gift Card Credentials"
    end
  end

  def show
    @gift_card = GiftCard.find_by(id: params[:id], card_number: params[:card_number])
    if @gift_card
      @transactions = @gift_card.transactions.order('created_at desc').limit(5)
    else
      redirect_to root_path, alert: "Invalid Card Details."
    end
  end

end
