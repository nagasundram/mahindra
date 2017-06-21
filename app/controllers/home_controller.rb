class HomeController < ApplicationController
  def index
    if user_signed_in? && current_user.is_admin?
      @active_cards = GiftCard.active_cards.count
      @redeemed_today = Transaction.where('DATE(updated_at) = ?', Date.today).sum(:redeemed_value).to_i
      @total_gift_card_balance = GiftCard.sum(:balance).to_i
      # @redeemed_this_month = Transaction.where('MONTH(updated_at) = ?', Date.today.month).sum(:redeemed_value).to_i
      # @will_expire_cards = GiftCard.where('MONTH(expiry) = ?', Date.today.month).count
      @transactions= Transaction.group('DATE(updated_at)').order("updated_at desc").sum(:redeemed_value)
      @monthly_summary = {}
      (1.month.ago.to_date..Date.today).each {|x| @monthly_summary[x] = 0}
        @monthly_summary.each do |k,v|
        if(@transactions.has_key?(k))
          @monthly_summary[k] = @transactions[k]
        end
      end
    end
  end
end
