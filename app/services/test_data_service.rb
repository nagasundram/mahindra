class TestDataService
  def call
    User.find(2).try(:destroy)
    user = User.find_or_create_by!(email: 'mahindraretail@yopmail.com') do |user|
        user.id = 2
        user.password = "12341234"
        user.password_confirmation = "12341234"
        user.store_address = "Test Street"
        user.store_name = "firstcry"
        user.store_code = "1234"
        user.name = "kinder"
        user.status = "Active"
        user.region = "India"
        user.city = "Bangalore"
        user.state = "KA"
        user.pincode = "560025"
      end
      GiftCard.find_by(card_number: '1234123412341234').try(:destroy)
      gift_card = GiftCard.find_or_create_by!(card_number: '1234123412341234') do |gd|
        gd.id = 1
        gd.card_number = '1234123412341234'
        gd.pin = "123456"
        gd.balance = 10000
        gd.expiry = Time.now + 90.days
        gd.username = "Anand"
      end
  end
end
