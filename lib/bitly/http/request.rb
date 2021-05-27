require "json"
require "uri"

module Bitly
  module HTTP
    class Request
      attr_reader :method
      attr_reader :params
      attr_reader :headers


      def initialize(uri: , method: "GET", params: {}, headers: {})
        errors = []
        @uri = uri
        errors << "uri must be an object of type URI. Received a #{uri.class}" unless uri.kind_of?(URI)
        @method = method
        errors << "method must be a valid HTTP method. Received: #{method}." unless HTTP_METHODS.include?(method)
        @params = params
        errors << "params must be a hash. Received: #{params.inspect}." unless params.kind_of?(Hash)
        @headers = headers
        errors << "headers must be a hash. Received: #{headers.inspect}." unless headers.kind_of?(Hash)
        raise ArgumentError, errors.join("\n") if errors.any?
      end

      def uri
        uri = @uri.dup
        return uri if HTTP_METHODS_WITH_BODY.include?(@method)
        if uri.query
          existing_query = URI.decode_www_form(uri.query)
          new_query = hash_to_arrays(@params)
          uri.query = URI.encode_www_form((existing_query + new_query).uniq)
        else
          uri.query = URI.encode_www_form(@params) if @params.any?
        end
        uri
      end

      def body
        return nil if HTTP_METHODS_WITHOUT_BODY.include?(@method)
        return JSON.generate(params)
      end

      private

      def hash_to_arrays(hash)
        hash.map do |key, value|
          if value.is_a?(Array)
            value.map { |v| [key, v] }
          else
            [[key, value]]
          end
        end.flatten(1)
      end

      HTTP_METHODS_WITHOUT_BODY = [
        "GET",
        "HEAD",
        "DELETE",
        "TRACE",
        "OPTIONS"
      ]

      HTTP_METHODS_WITH_BODY = [
        "POST",
        "PUT",
        "PATCH",
        "CONNECT"
      ]

      HTTP_METHODS = HTTP_METHODS_WITH_BODY + HTTP_METHODS_WITHOUT_BODY
    end
  end
end