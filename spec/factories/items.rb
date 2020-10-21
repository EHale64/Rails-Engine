FactoryBot.define do
  factory :item do
    name { Faker::Beer.name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Commerce.price(range: 0..10.0) }
    merchant
  end
end
