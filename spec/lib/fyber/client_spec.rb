require './spec/spec_helper'

describe Fyber::Client do
  describe 'initialize' do
    it 'raises an exception when an api_key argument is missing' do
      expect { described_class.new() }.to raise_exception
    end


    it 'does not raise an exception when an api_key is given' do
      expect { described_class.new(api_key: 'my_api_key') }.not_to raise_exception
    end


    context 'when default configuration is not overridden' do
      before(:all) do
        @default_config_client = described_class.new(api_key: 'my_api_key')
        @default_configuration = @default_config_client.send(:default_configuration)
      end

      it 'assigns base_url from config file' do
        expect(@default_config_client.base_url).to eq(@default_configuration['base_url'])
      end


      it 'assigns base_url from config file' do
        expect(@default_config_client.api_version).to eq(@default_configuration['api_version'])
      end
    end

    context 'when default configuration is overridden' do
      before(:all) do
        @custom_base_url = 'www.mycustomapi.com'
        @custom_api_version = 'v8'
        @custom_config_client = described_class.new(api_key: 'my_api_key', options: {'base_url' => @custom_base_url, 'api_version' => @custom_api_version})
      end


      it 'assigns base_url from given params' do
        expect(@custom_config_client.base_url).to eq(@custom_base_url)
      end


      it 'assigns base_url from given params' do
        expect(@custom_config_client.api_version).to eq(@custom_api_version)
      end
    end

  end


  describe 'build_path' do
    before(:all) do
      @client = described_class.new(api_key: 'my_api_key', options: {version: 'v8'})
      @request = Fyber::Request.new(http_method: 'get', uri: 'offers', format: 'xml')
    end

    it 'uses api version defined in client' do
      expect( @client.build_path(@request)).to start_with(@client.api_version)
    end


    it 'uses request uri' do
      expect( @client.build_path(@request)).to start_with("#{@client.api_version}/#{@request.uri}")
    end


    it 'uses request format' do
      expect( @client.build_path(@request)).to end_with(".#{@request.format}")
    end
  end
end