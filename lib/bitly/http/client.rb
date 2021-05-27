module Bitly
    module HTTP
        class Client
            def initialize(adapther=Bitly::HTTP::Adapters::NetHTTP.new)
                @adapther = adapther
                raise ArgumentError, "Adapter must have a request method", unless @adapther.respond_to?(:request)

            end
            