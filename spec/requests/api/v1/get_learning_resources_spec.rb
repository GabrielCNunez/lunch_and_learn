require 'rails_helper'

describe 'The Learning Resources API' do
  let(:response_body_1) { File.open('./spec/fixtures/sample_json/laos_video_search.json')}
  let(:response_body_2) { File.open('./spec/fixtures/sample_json/laos_images_search.json')}

  it 'can get learning resources based on the name of a country' do
    stub_request(:get, /googleapis/).to_return(status: 200, body: response_body_1)
    stub_request(:get, /unsplash/).to_return(status: 200, body: response_body_2)
    
    country = 'laos'

    get "/api/v1/learning_resources?country=#{country}"

    expect(response).to be_successful

    resources = JSON.parse(response.body,symbolize_names: true)

    expect(resources).to be_a(Hash)
    expect(resources).to have_key(:data)
    expect(resources[:data]).to be_an(Array)

    resources[:data].each do |resource|
      expect(resource).to have_key(:id)
      expect(resource[:id]).to eq(nil)

      expect(resource).to have_key(:type)
      expect(resource[:type]).to eq("learning_resource")

      expect(resource).to have_key(:attributes)
      expect(resource[:attributes]).to have_key(:country)
      expect(resource[:attributes][:country]).to eq(country)

      expect(resource[:attributes]).to have_key(:video)
      expect(resource[:attributes][:video]).to be_a(Hash)
      expect(resource[:attributes][:video]).to have_key(:title)
      expect(resource[:attributes][:video]).to have_key(:youtube_video_id)
      
      expect(resource[:attributes]).to have_key(:images)
      expect(resource[:attributes][:images]).to be_an(Array)

      resource[:attributes][:images].each do |image|
        expect(image).to have_key(:alt_tag)
        expect(image).to have_key(:url)
        expect(image.keys.size).to eq(2)
      end

      expect(resource[:attributes].keys.size).to eq(3)
    end
  end
end