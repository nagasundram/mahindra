class HomeController < ApplicationController
  def index
    if user_signed_in? && current_user.is_admin?
      @active_cards = GiftCard.active_cards.count
      @redeemed_today = Transaction.where('DATE(updated_at) = ?', Date.today).sum(:redeemed_value).to_i
      @total_gift_card_balance = GiftCard.active_cards.sum(:balance).to_i
      @redeemed_this_month = Transaction.where(updated_at: 1.month.ago.to_date..(Date.today+1.day)).sum(:redeemed_value).to_i
      @expired_cards = GiftCard.where(expiry: Date.today.beginning_of_month..Date.today).count
      @transactions= Transaction.group('DATE(updated_at)').sum(:redeemed_value)
      @redeemed_percentage = (Transaction.sum(:redeemed_value).to_f/GiftCard.active_cards.sum(:balance).to_f*100)
      @monthly_summary = {}
      (1.month.ago.to_date..Date.today).each {|x| @monthly_summary[x] = 0}
        @monthly_summary.each do |k,v|
        if(@transactions.has_key?(k))
          @monthly_summary[k] = @transactions[k]
        end
        @labels = []
        @data = []
        @colors = []
        @border_colors = []
        @monthly_summary.each do |k,v|
          @labels.push(k.to_s)
          @data.push(v.to_f)
          @colors.push("rgba(#{Random.rand(0..255)}, #{Random.rand(0..255)}, #{Random.rand(0..255)}, 0.2)")
          @border_colors.push("rgba(#{Random.rand(0..255)}, #{Random.rand(0..255)}, #{Random.rand(0..255)}, 0.4)")
        end
      end
    end
  end
end
