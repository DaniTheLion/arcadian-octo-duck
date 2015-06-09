require './spec/spec_helper'

describe Fyber::Request do
  describe 'initialize' do
    mandatory_arguments = { uri: 'some_uri', http_method: 'get' }

    it 'raises an exception when a uri argument is missing' do
      invalid_arguments = mandatory_arguments.dup.delete(:uri)
      expect{ described_class.new(invalid_arguments) }.to raise_exception
    end


    it 'raises an exception when a http_method argument is missing' do
      invalid_arguments = mandatory_arguments.dup.delete(:http_method)
      expect{ described_class.new(invalid_arguments) }.to raise_exception
    end


    it 'does not raise an exception when both a http_method and uri arguments are given' do
      expect{ described_class.new(mandatory_arguments) }.not_to raise_exception
    end
  end


  describe 'set_hashkey!' do
    it 'adds a hashkey entry to params according to the calculation' do
      req_params = { a: 100, c: 300, b: 200 }
      api_key = 'some_api_key'

      req = described_class.new(http_method: 'get', uri: 'some_uri', params: req_params)
      hashkey = Digest::SHA1.hexdigest("a=100&b=200&c=300&#{api_key}")

      req.set_hashkey!(api_key)
      expect(req.params).to include('hashkey' => hashkey)
    end
  end


  describe 'set_timestamp!' do
    it 'adds a hashkey entry to params according to the calculation' do
      req = described_class.new(http_method: 'get', uri: 'some_uri')

      req.set_timestamp!
      expect(req.params).to include('timestamp' => a_value > Time.now.to_i - 30)
    end
  end
end