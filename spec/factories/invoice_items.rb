FactoryBot.define do
  factory :invoice_item do
    item_id { nil }
    invoice_id { nil }
    quantity { 1 }
    unit_price { 1 }
  end
end
