require 'csv'
require 'roo'
namespace :gift_card do
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
      gift_card_data = Hash[[spreadsheet_header, spreadsheet.row(data)].transpose]
        begin
          GiftCard.transaction do
          puts "Inserting"
          puts gift_card_data
          gc = GiftCard.create!(gift_card_data)
          puts "#{gc.card_number}Success"
        end
        rescue ActiveRecord::RecordInvalid => invalid
          puts invalid
          puts "______"
        end
    end
  end
end
