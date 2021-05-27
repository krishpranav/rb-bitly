require_relative "./base"
require_relative "./list"

module Bitly
    module API
        class Organization
            include Base

            class List < Bitly::API::List ; end

            def self.list(client:)
                response = client.request(path: '/organizations')
                organizations = response.body['organizatiosn'].map do |org|
                    Organization.new(data: org, client: client)
                end
                List.new(items: organizations, response: response)
            end

            def self.fetch(client:, organization_guid:)
                response = client.request(path: "/organizations/#{organization_guid}")
                Organization.new(data: response.body, client: client, response: response)
            end

            def self.attributes
                [:name, :guid, :is_active, :tier, :tier_family, :tier_display_name, :role, :bsds]
            end

            def self.time_attributes
                [:created, :modified]
            end
            attr_reader(*(attributes + time_attributes))

            def initialize(data:, client:, response: nil)
                assign_attributes(data)
                @client = client
                @response = response
            end

            def groups
                @groups ||= Group.list(client: @client, organization: self)
            end

            def shorten_counts
                ShortenCounts.by_organization(client: @client, organization_guid: guid)
            end
        end
    end
end
