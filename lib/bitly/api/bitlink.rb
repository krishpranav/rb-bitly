require_relative "./base"
require_relative "./list"

module Bitly
  module API

    class Bitlink
      autoload :PaginatedList, File.join(File.dirname(__FILE__), "bitlink/paginated_list.rb")
      autoload :Deeplink, File.join(File.dirname(__FILE__), "bitlink/deeplink.rb")
      autoload :ClicksSummary, File.join(File.dirname(__FILE__), "bitlink/clicks_summary.rb")
      autoload :LinkClick, File.join(File.dirname(__FILE__), "bitlink/link_click.rb")

      include Base

      class List < Bitly::API::List ; end


      def self.shorten(client:, long_url:, domain: nil, group_guid: nil)
        response = client.request(
          path: "/shorten",
          method: "POST",
          params: {
            "long_url" => long_url,
            "domain" => domain,
            "group_guid" => group_guid
          })
        new(data: response.body, client: client, response: response)
      end


      def self.create(client:, long_url:, domain: nil, group_guid: nil, title: nil, tags: nil, deeplinks: nil)
        response = client.request(
          path: "/bitlinks",
          method: "POST",
          params: {
            "long_url" => long_url,
            "domain" => domain,
            "group_guid" => group_guid,
            "title" => title,
            "tags" => tags,
            "deeplinks" => deeplinks
          }
        )
        new(data: response.body, client: client, response: response)
      end


      def self.fetch(client:, bitlink:)
        response = client.request(path: "/bitlinks/#{bitlink}")
        new(data: response.body, client: client, response: response)
      end


      def self.expand(client:, bitlink:)
        response = client.request(path: "/expand", method: "POST", params: { "bitlink_id" => bitlink })
        new(data: response.body, client: client, response: response)
      end


      def self.list(
        client:,
        group_guid:,
        size: nil,
        page: nil,
        keyword: nil,
        query: nil,
        created_before: nil,
        created_after: nil,
        modified_after: nil,
        archived: nil,
        deeplinks: nil,
        domain_deeplinks: nil,
        campaign_guid: nil,
        channel_guid: nil,
        custom_bitlink: nil,
        tags: nil,
        encoding_login: nil
      )
        params = {
          "size" => size,
          "page" => page,
          "keyword" => keyword,
          "query" => query,
          "created_before" => created_before,
          "created_after" => created_after,
          "modified_after" => modified_after,
          "archived" => archived,
          "deeplinks" => deeplinks,
          "domain_deeplinks" => domain_deeplinks,
          "campaign_guid" => campaign_guid,
          "channel_guid" => channel_guid,
          "custom_bitlink" => custom_bitlink,
          "tags" => tags,
          "encoding_login" => encoding_login
        }
        response = client.request(path: "/groups/#{group_guid}/bitlinks", params: params)
        bitlinks = response.body["links"].map do |link|
          new(data: link, client: client)
        end
        PaginatedList.new(items: bitlinks, response: response, client: client)
      end


      def self.sorted_list(client:, group_guid:, sort: "clicks", unit: nil, units: nil, unit_reference: nil, size: nil)
        params = {
          "unit" => unit,
          "units" => units,
          "unit_reference" => unit_reference,
          "size" => size
        }
        response = client.request(path: "/groups/#{group_guid}/bitlinks/#{sort}", params: params)
        link_clicks = response.body["sorted_links"]
        bitlinks = response.body["links"].map do |link|
          clicks = link_clicks.find { |c| c["id"] == link["id"] }["clicks"]
          new(data: link, client: client, clicks: clicks)
        end.sort { |a, b| b.clicks <=> a.clicks }
        List.new(items: bitlinks, response: response)
      end

      def self.attributes
        [:archived, :tags, :title, :created_by, :long_url, :client_id, :custom_bitlinks, :link, :id]
      end
      def self.time_attributes
        [:created_at]
      end
      attr_reader(*(attributes + time_attributes))
      attr_reader :deeplinks, :clicks

      def initialize(data:, client:, response: nil, clicks: nil)
        assign_attributes(data)
        if data["deeplinks"]
          @deeplinks = data["deeplinks"].map { |data| Deeplink.new(data: data) }
        else
          @deeplinks = []
        end
        @clicks = clicks
        @client = client
        @response = response
      end


      def update(
        archived: nil,
        tags: nil,
        created_at: nil,
        title: nil,
        deeplinks: nil,
        created_by: nil,
        long_url: nil,
        client_id: nil,
        custom_bitlinks: nil,
        link: nil,
        id: nil,
        references: nil
      )
        @response = @client.request(
          path: "/bitlinks/#{@id}",
          method: "PATCH",
          params: {
            "archived" => archived,
            "tags" => tags,
            "created_at" => created_at,
            "title" => title,
            "deeplinks" => deeplinks,
            "created_by" => created_by,
            "long_url" =>long_url ,
            "client_id" => client_id,
            "custom_bitlinks" => custom_bitlinks,
            "link" => link,
            "id" => id,
            "references" => references
          }
        )
        assign_attributes(@response.body)
        self
      end


      def clicks_summary(unit: nil, units: nil, unit_reference: nil, size: nil)
        ClicksSummary.fetch(client: @client, bitlink: id, unit: unit, units: units, unit_reference: unit_reference, size: size)
      end

      def link_clicks(unit: nil, units: nil, unit_reference: nil, size: nil)
        LinkClick.list(client: @client, bitlink: id, unit: unit, units: units, unit_reference: unit_reference, size: size)
      end
    end
  end
end