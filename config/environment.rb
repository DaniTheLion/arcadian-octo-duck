require 'rubygems'
require 'bundler'
require './lib/fyber'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load a`ll the environment specific gems