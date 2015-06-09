require './spec/spec_helper'

describe Fyber::Response do
  describe 'initialize' do
    it 'raises an exception when a response argument is missing' do
      expect{ described_class.new() }.to raise_exception
    end


    it 'does not raise an exception when a response object is given' do
      response_mock = double()
      allow(response_mock).to receive(:body).and_return({}.to_json)
      allow(response_mock).to receive(:headers).and_return("")

      expect{ described_class.new(response: response_mock) }.not_to raise_exception
    end
  end


  describe 'valid_signature?' do
    before(:each) do
      @response_body = { 'code'=>'NO_CONTENT', 'message'=>'Successful request, but no offers are currently available for this user.' }
      @padding = 'some_string'

      @response_mock = double()
      allow(@response_mock).to receive(:body).and_return(@response_body.to_json)
    end


    it 'returns true when signature is valid' do
      valid_signature = Digest::SHA1.hexdigest(@response_body.to_json + @padding)
      allow(@response_mock).to receive(:headers).and_return({'X-Sponsorpay-Response-Signature' => valid_signature})

      response = described_class.new(response: @response_mock)
      expect( response.valid_signature?(@padding)).to eq(true)
    end


    it 'returns false when signature is invalid' do
      invalid_signature = 'This is by no means valid..'
      allow(@response_mock).to receive(:headers).and_return({'X-Sponsorpay-Response-Signature' => invalid_signature})

      response = described_class.new(response: @response_mock)
      expect( response.valid_signature?(@padding)).to eq(false)
    end
  end
end