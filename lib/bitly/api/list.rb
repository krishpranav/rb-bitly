module Bitly
    module API
        class List
            include Enumerable
            attr_reader :response

            def initialize(items:, response:)
                @items = items
                @response = response
            end

            def each
                @items.each { |item| yield item }
            end
        end 
    end
end
