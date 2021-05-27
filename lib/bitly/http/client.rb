module Bitly
    module HTTP
        class Client
            def initialize(adapther=Bitly::HTTP::Adapters::NetHTTP.new)
                @adapther = adapther
                raise ArgumentError, "Adapter must have a request method", unless @adapther.respond_to?(:request)

            end

            def request(request)
                status, body, headers, success = @adapther.request(request)
                response = Bitly::HTTP::Response.new(status: status, body: body, headers: headers, request: request)
                if success
                    return response
                else
                    raise Bitly::Error, response
                end
            end
        end
    end
end
