FactoryBot.define do
  factory :item do
    name { Faker::Item.name }
    description { Faker::Item.description }
    unit_price { Faker::Commerce.price(range: 0..10.0) }
  end
end
