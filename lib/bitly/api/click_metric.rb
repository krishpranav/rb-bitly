require "time"
require_relative "./base"
require_relative "./list"

module Bitly
    module API
        class ClickMetric
            include Base
            
            class List < Bitly::API::List
                attr_reader :units, :unit_reference, :unit, :facet
                def initialize(items, response:, units:, unit_reference:, unit:, facet:)
                    super(items: items, response: response)
                    @units = units

                    begin
                        @unit_reference = Time.parse(unit_reference) if unit_reference
                    rescue TypeError
                        @unit_reference = Time.at(unit_reference)
                    end
                    @unit = unit
                    @facet = facet
                end
            end
            