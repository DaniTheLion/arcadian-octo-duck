require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'

class FyberChallenge < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/views'

  get '/' do
    erb :index
  end

  get '/offers.json' do
    begin
      res = client.get_offers(params)
      json offers: res.body['offers']
    rescue => e
      status 400
      json error_msg: e.message
    end
  end

  private
    def client
      api_key = config.delete('api_key')
      Fyber::Client.new(api_key: api_key, options: config)
    end


    def config
      @config ||= YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'fyber_client.yml'))
    end
end
