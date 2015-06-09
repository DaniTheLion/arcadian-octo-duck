require 'uri'
require 'digest/sha1'
module Fyber
  class Request

    attr_reader :http_method, :uri, :format, :params

    # Named parameters
    def initialize(http_method:, uri:, params: {}, format: 'json')
      @http_method = http_method
      @uri         = uri
      @format      = format
      @params      = params
    end


    def set_hashkey!(api_key)
      q = sorted_params_query
      hashkey = Digest::SHA1.hexdigest(q + '&' + api_key)
      @params['hashkey'] = hashkey
    end


    def set_timestamp!
      @params['timestamp'] = Time.now.to_i
    end


    private
      def sorted_params_query
        URI.encode_www_form(@params.sort_by{ |k,_| k })
      end
  end
end