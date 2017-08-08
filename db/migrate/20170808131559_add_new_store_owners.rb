class AddNewStoreOwners < ActiveRecord::Migration[5.1]
  def change
    User.create([{
    email: "4071.hyderabad@mahindraretail.com",
    name: "MM-BANJARA HILLS HYD",
    store_name: "MM-BANJARA HILLS HYD",
    store_code: "4071",
    region: "South",
    city: "Hyderabad",
    state: "TELANGANA",
    pincode: "500034",
    store_address: "shop No 4A& 4B keerti & Pride Towers plot no 11& 12 bearing Municipal no 8-2-120-/86&8-2-120/86/1 ,Road No 12, Banjara Hills, Hyderabad - 500034"
  },
  {
    email: "1039.delhi@mahindraretail.com",
    name: "MM-MAHIPAPUR",
    store_name: "MM-MAHIPAPUR",
    store_code: "1039",
    region: "North",
    city: "New Delhi",
    state: "DELHI",
    pincode: "110037",
    store_address: "Khasra No.338/2,1st & 2nd Floor,Near 'W' Brand Showroom,Rangpuri, NH-8 Highway,New Delhi - 110037"
  }]) do |user|
      user.status = 1
      user.password = "#{user.store_code}-mgr"
      user.password_confirmation = "#{user.store_code}-mgr"
    end
  end
end
