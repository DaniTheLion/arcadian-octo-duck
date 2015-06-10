require 'json'
require 'digest/sha1'
module Fyber
  class Response
    attr_reader :code, :body, :headers

    def initialize(response:)
      @raw = response
      @headers = @raw.headers
      @body = JSON.parse(@raw.body)
      @code = @body['code']
    end


    def valid_signature?(padding)
      signature = @headers['X-Sponsorpay-Response-Signature']
      Digest::SHA1.hexdigest(@raw.body + padding) == signature
    end

    def successful?
      @raw.success?
    end
  end
end