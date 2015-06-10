require File.expand_path '../spec_helper.rb', __FILE__

describe FyberChallenge do
  it 'should allow accessing the home page' do
    get '/'
    expect(last_response.status).to eq(200)
  end

  describe 'GET /offers.json' do
    it 'should invoke the FyberAPI client' do
      expect_any_instance_of(Fyber::Client).to receive(:get_offers)
      get '/offers.json'
    end


    context 'when Fyber API call is successfull' do
      it 'should return the offers returned by the Fyber client' do
        successfull_raw_response = Rack::MockResponse.new(200, {}, { 'offers' => []}.to_json )
        successfull_mock_response = Fyber::Response.new(response: successfull_raw_response)
        allow_any_instance_of(Fyber::Client).to receive(:get_offers).and_return(successfull_mock_response)

        get '/offers.json'
        expect(last_response.body).to eq(successfull_mock_response.body.to_json)
      end
    end


    context 'when Fyber API call is errornous' do
      it 'should return 400' do
        allow_any_instance_of(Fyber::Client).to receive(:get_offers).and_raise('Something went bad.')

        get '/offers.json'
        expect(last_response.status).to eq(400)
      end
    end
  end
end