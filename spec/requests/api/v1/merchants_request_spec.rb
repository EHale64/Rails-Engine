require 'rails_helper'

RSpec.describe 'Merchants API' do
  it "can get one Merchant by it's id" do
    id = create(:merchant).id
    get "/api/v1/merchants/#{id}"

    merchant =  JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(merchant[:data][:attributes]).to have_key(:id)
    expect(merchant[:data][:attributes][:id]).to eq(id)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)

    expect(merchant[:data][:attributes]).to_not  have_key(:created_at)
    expect(merchant[:data][:attributes]).to_not  have_key(:updated_at)
  end

  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can create a merchant" do
    merchant_params = ({ name: 'John Smith' })

    post "/api/v1/merchants", params: merchant_params
    new_merchant = Merchant.last

    expect(response).to be_successful
    expect(new_merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: 'Jane Smith' }

    patch "/api/v1/merchants/#{id}", params: merchant_params
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq('Jane Smith')
  end

  it "can destroy a merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    expect{ delete "/api/v1/merchants/#{merchant.id}"}.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can get all items for a merchant" do
    merchant = create(:merchant)
    3.times { create(:item, merchant_id: merchant.id)}
    rand_items = create_list(:item, 2)

    get "/api/v1/merchants/#{merchant.id}/items"
    items = JSON.parse(response.body, symbolize_names: true)

    expect(Item.all.count).to eq(5)
    expect(items[:data][:relationships][:items][:data].count).to eq(3)
    expect(items[:data][:relationships][:items][:data].first).to have_key(:id)
    expect(items[:data][:relationships][:items][:data].first[:id]).to be_an(Integer)
  end
end
