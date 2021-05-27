require_relative "../base"

module Bitly
  module API
    class Bitlink
      class ClicksSummary
        include Base

        def self.fetch(client:, bitlink:, unit: nil, units: nil, unit_reference: nil, size: nil)
          response = client.request(
            path: "/bitlinks/#{bitlink}/clicks/summary",
            params: {
              "unit" => unit,
              "units" => units,
              "unit_reference" => unit_reference,
              "size" => size
            }
          )
          new(data: response.body, response: response)
        end

        def self.attributes
          [:units, :unit, :unit_reference, :total_clicks]
        end
        attr_reader(*attributes)

        def initialize(data:, response: nil)
          assign_attributes(data)
          @response = response
        end
      end
    end
  end
end
