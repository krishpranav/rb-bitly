# frozen_string_literal: true
require "json"

module Bitly
  module HTTP
    class Response

      attr_reader :status
      attr_reader :body
      attr_reader :headers
      attr_reader :request

      def initialize(status:, body:, headers:, request: nil)
        errors = []
        @status = status
        errors << "Status must be a valid HTTP status code. Received #{status}" unless is_status?(status)
        if body.nil? || body.empty?
          @body = nil
        else
          begin
            @body = JSON.parse(body)
          rescue JSON::ParserError
            @body = {
              "message" => body
            }
          end
        end
        @headers = headers
        errors << "Headers must be a hash. Received #{headers}" unless headers.is_a?(Hash)
        @request = request
        errors << "Request must be a Bitly::HTTP::Request. Received #{request}" if request && !request.is_a?(Request)
        raise ArgumentError, errors.join("\n"), caller if errors.any?
      end

      private

      def is_status?(status)
        !!status.match(/\A[1-5][0-9][0-9]\z/)
      end
    end
  end
end