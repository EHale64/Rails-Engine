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
  end
end
