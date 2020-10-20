require 'csv'

desc 'Import CSV data to database'
namespace :db do
  task :set_up_db do
    ActiveRecord::Tasks::DatabaseTasks.env = 'development'
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute

    puts 'Injecting Merchant Data'

    csv_merchants = CSV.read('./lib/csvs/merchants.csv', headers: true, header_converters: :symbol)
    csv_merchants.each do |row|
      Merchant.create!(row.to_hash)
    end

    puts 'Injecting Customer Data'

    csv_customers = CSV.read('./lib/csvs/customers.csv', headers: true, header_converters: :symbol)
    csv_customers.each do |row|
      Customer.create!(row.to_hash)
    end

    puts 'Injecting Item Data'

    csv_items = CSV.read('./lib/csvs/items.csv', headers: true, header_converters: :symbol)
    csv_items.each do |row|
      item = Item.create!(row.to_hash)
      item.unit_price = item.unit_price.to_f / 100
      item.save
    end

    puts 'Injecting Invoice Data'

    csv_invoices = CSV.read('./lib/csvs/invoices.csv', headers: true, header_converters: :symbol)
    csv_invoices.each do |row|
      Invoice.create!(row.to_hash)
    end

    puts 'Injecting InvoiceItem Data'

    csv_invoice_items = CSV.read('./lib/csvs/invoice_items.csv', headers: true, header_converters: :symbol)
    csv_invoice_items.each do |row|
      invoice_item = InvoiceItem.create!(row.to_hash)
      invoice_item.unit_price = invoice_item.unit_price.to_f / 100
      invoice_item.save
    end

    puts 'Injecting Transaction Data'

    csv_transactions = CSV.read('./lib/csvs/transactions.csv', headers: true, header_converters: :symbol)
    csv_transactions.each do |row|
      Transaction.create!(row.to_hash)
    end

    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end

    puts 'Database has been setup with CSV!'
  end
end
