require_relative "./base"

module Bitly
    module API
        class ShortenCounts
            include Base

            def self.attributes
                [:units, :facet, :unit_reference, :unit]
            end

            attr_reader(*attributes)
            attr_reader :metrics

            Metric = Struct.new(:key, :value)
            