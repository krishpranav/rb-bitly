module Bitly

    class Error < StandardError
        attr_reader :status_code
        attr_reader :description
        attr_reader :response 

        def initialize(response)
            @response = response
            @status_code = response.status
            @description = response.body["description"]
            @message = "[#{@status_code}] #{response.body["message"]}"
            super(@message)
        end
    end
end
