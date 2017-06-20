class TestDataService
  def call
    user = User.find_or_create_by!(email: 'testowner@yopmail.com') do |user|
        user.password = "12341234"
        user.password_confirmation = "12341234"
        user.store_address = "Test Street"
        user.store_name = "Apple"
        user.store_code = "1234"
        user.name = "Naga"
        user.status = "Active"
        user.region = "India"
        user.city = "Bangalore"
        user.state = "KA"
        user.pincode = "560001"
      end
      gift_card = GiftCard.find_or_create_by!(card_number: '1234123412341234') do |gd|
        gd.card_number = "1234123412341234",
        gd.pin = "1234",
        gd.balance = 10000,
        gd.expiry = Time.now + 90.days
      end
  end
end
