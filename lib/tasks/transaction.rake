namespace :transaction do
  desc "TODO"
  task dumb: :environment do
    puts "Enter file name"
    file = STDIN.gets.chomp
    case File.extname(URI.parse(file).path)
      when '.csv' then spreadsheet = Roo::CSV.new(file)
      when '.xls' then spreadsheet = Roo::Excel.new(file)
      when '.xlsx' then spreadsheet = Roo::Excelx.new(file)
      else raise "Unknown file type: #{file}"
    end
    spreadsheet_header = spreadsheet.row(1).reject {|r| r.blank? }
    (2..spreadsheet.last_row).each.with_index do |data, index|
      transaction_data = Hash[[spreadsheet_header, spreadsheet.row(data)].transpose]
        begin
          Transaction.transaction do
          puts "Inserting"
          puts transaction_data
          @user = User.find_by(store_code: transaction_data["store_code"])
          @gift_card = GiftCard.find_by(card_number: transaction_data["card_number"])
          t = Transaction.new(transaction_data.except!("store_code", "card_number"))
          if @user.present?
            t.user = @user
            t.gift_card = @gift_card
            t.save!
            puts "Success"
            puts "______"
          else
            puts "%%%%%%%%%%%%%%%%%%%%%%%User or Gc not present%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          end
        end
        rescue ActiveRecord::RecordInvalid => invalid
          puts "@@@@@@@@@@@@@@@@@@ERROR@@@@@@@@@@@@@@@@@@@@@"
          puts invalid
          puts "@@@@@@@@@@@@@@@@@@ERROR@@@@@@@@@@@@@@@@@@@@@"
        end
    end
  end

end
