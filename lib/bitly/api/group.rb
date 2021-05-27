require_relative "./base"
require_relative "./list"

module Bitly
  module API

    class Group
      autoload :Preferences, File.join(File.dirname(__FILE__), "group/preferences.rb")

      include Base


      class List < Bitly::API::List ; end

      def self.list(client:, organization_guid: nil)
        params = { "organization_guid" => organization_guid }
        response = client.request(path: "/groups", params: params)
        groups = response.body["groups"].map do |group|
          Group.new(data: group, client: client)
        end
        List.new(items: groups, response: response)
      end


      def self.fetch(client:, group_guid:)
        response = client.request(path: "/groups/#{group_guid}")
        Group.new(data: response.body, client: client, response: response)
      end


      def self.attributes
        [:name, :guid, :is_active, :role, :bsds, :organization_guid]
      end

      def self.time_attributes
        [:created, :modified]
      end

      attr_reader(*(attributes + time_attributes))


      def initialize(data:, client:, response: nil, organization: nil)
        assign_attributes(data)
        @client = client
        @response = response
        @organization = organization
      end

 
      def organization
        @organization ||= Organization.fetch(client: @client, organization_guid: organization_guid)
      end


      def preferences
        @preferences ||= Group::Preferences.fetch(client: @client, group_guid: guid)
      end


      def tags
        @tags ||= @client.request(path: "/groups/#{guid}/tags").body["tags"]
      end


      def update(name: nil, organization_guid: nil, bsds: nil)
        params = {
          "name" => name,
          "bsds" => bsds
        }
        if organization_guid
          params["organization_guid"] = organization_guid
          @organization = nil
        end
        @response = @client.request(path: "/groups/#{guid}", method: "PATCH", params: params)
        assign_attributes(@response.body)
        self
      end


      def delete
        @response = @client.request(path: "/groups/#{guid}", method: "DELETE")
        return nil
      end


      def shorten_counts
        ShortenCounts.by_group(client: @client, group_guid: guid)
      end


      def bitlinks
        Bitly::API::Bitlink.list(client: @client, group_guid: guid)
      end


      def referring_networks(unit: nil, units: nil, unit_reference: nil, size: nil)
        ClickMetric.list_referring_networks(
          client: @client,
          group_guid: guid,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end

      def countries(unit: nil, units: nil, unit_reference: nil, size: nil)
        ClickMetric.list_countries_by_group(
          client: @client,
          group_guid: guid,
          unit: unit,
          units: units,
          unit_reference: unit_reference,
          size: size
        )
      end
    end
  end
end