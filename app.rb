require 'sinatra'
require 'sinatra/reloader' if development?

class FyberChallenge < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/views'

  get '/' do
    erb :index
  end
end
