require 'yaml'
require 'faraday'
require 'faraday/adapter/net_http_persistent'

module Fyber
  class Client

    attr_reader :base_url, :api_version, :api_key, :default_params

    def initialize(api_key:, options: {})
      @api_key        = api_key
      @config         = default_configuration.merge(options)
      @base_url       = @config['base_url']
      @api_version    = @config['api_version']
      @default_params = @config['default_params']
    end

    def get(uri, params)
      request = Request.new(http_method: :get, uri: uri, params: @default_params.merge(params))
      handle(request)
    end

    def get_offers(params)
      get('offers', params)
    end


    def build_path(request)
      [@api_version, request.uri].join('/') + '.' + request.format
    end


    private
      def handle(request)
        path = build_path(request)

        request.set_timestamp!
        request.set_hashkey!(@api_key)

        raw_response = connection.get path, request.params
        raise StandardError.new('Bad Request') unless raw_response.success?

        response = Response.new(response: raw_response)
        raise StandardError.new('Response is invalid!') unless response.valid_signature?(@api_key)
        response
      end


      def default_configuration
        @@default_configuration ||= YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'api_config.yml'))
      end


      def connection
        @connection ||= Faraday.new(:url => @base_url) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  :net_http_persistent     # Enable keep alive header
        end
      end
  end
end