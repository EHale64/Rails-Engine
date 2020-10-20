require 'rails_helper'

RSpec.describe 'Items API' do
  it "can get one Item by it's id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item =  JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(id)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_an(Integer)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_an(Integer)
  end

  it "can get a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_an(Integer)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
    end
  end

  xit "can create an Item" do
    item_params = ({ name: 'Arkham Horror the card game',
                     description: 'A Card Game of Arcane Mystery and Supernatural Terror for 1-2 Players',
                     unit_price: 3500,
                     merchant_id: 7
                   })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    new_item = Item.last

    expect(response).to be_successful
    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end
end
