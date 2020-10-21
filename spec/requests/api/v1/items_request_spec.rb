require 'rails_helper'

RSpec.describe 'Items API' do
  it "can get one Item by it's id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item =  JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item[:data][:attributes]).to have_key(:id)
    expect(item[:data][:attributes][:id]).to eq(id)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_an(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)

    expect(item[:data][:attributes]).to_not  have_key(:created_at)
    expect(item[:data][:attributes]).to_not  have_key(:updated_at)
  end

  it "can get a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:id)
      expect(item[:attributes][:id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "can create an Item" do
    merchant = create(:merchant)
    item_params = ({ name: 'Arkham Horror the card game',
                     description: 'A Card Game of Arcane Mystery and Supernatural Terror for 1-2 Players',
                     unit_price: 3500,
                     merchant_id: merchant.id
                   })

    post "/api/v1/items", params: item_params

    new_item = Item.last

    expect(response).to be_successful
    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do
    id = create(:item).id
    original_name = Item.last.name
    item_params = { name: 'Forbidden Desert: thirst for survival' }


    patch "/api/v1/items/#{id}", params: item_params
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(original_name)
    expect(item.name).to eq('Forbidden Desert: thirst for survival')
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect{ delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
