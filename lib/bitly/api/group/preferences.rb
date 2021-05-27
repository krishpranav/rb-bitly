require_relative "./../bsae.rb"

module Bitly
    module API 
        class Group

            class Prefereces
                include Base

                def self.attributes ; [:group_guid, :domain_preferences] ; end
                attr_reader(*attributes)

                def self.fetch(client:, group_guid:)
                    response = client.request(path: "/group/#{group_guid}/preferences")
                    new(data: response.body, client: client, response: response)
                end


                def initialize(data:, client:, response: nil)
                    assign_attributes(data)
                    @client = client
                    @response = response
                end
                