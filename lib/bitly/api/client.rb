module Bitly
    module API

      class Client
        USER_AGENT = "Ruby Bitly/#{Bitly::VERSION}"
  

        def initialize(http: Bitly::HTTP::Client.new, token:)
          @http = http
          @token = token
        end
  

        def request(path:, method: 'GET', params: {}, headers: {})
          params = params.select { |k,v| !v.nil? }
          headers = default_headers.merge(headers)
          uri = Bitly::API::BASE_URL.dup
          uri.path += path
          request = Bitly::HTTP::Request.new(uri: uri, method: method, params: params, headers: headers)
          @http.request(request)
        end
  
        def shorten(long_url:, domain: nil, group_guid: nil)
          Bitlink.shorten(client: self, long_url: long_url, domain: domain, group_guid: group_guid)
        end
  

        def create_bitlink(long_url:, domain: nil, group_guid: nil, title: nil, tags: nil, deeplinks: nil)
          Bitlink.create(client: self, long_url: long_url, domain: domain, group_guid: group_guid, title: title, tags: tags, deeplinks: deeplinks)
        end
  

        def bitlink(bitlink:)
          Bitlink.fetch(client: self, bitlink: bitlink)
        end
  

        def expand(bitlink:)
          Bitlink.expand(client: self, bitlink: bitlink)
        end
  
        def sorted_bitlinks(
          group_guid:,
          sort: "clicks",
          unit: nil,
          units: nil,
          unit_reference: nil,
          size: nil
        )
          Bitlink.sorted_list(
            client: self,
            group_guid: group_guid,
            sort: sort,
            unit: unit,
            units: units,
            unit_reference: unit_reference,
            size: size
          )
        end
  

        def update_bitlink(
          bitlink:,
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
          bitlink = Bitlink.new(data: { "id" => bitlink }, client: self)
          bitlink.update(
            archived: archived,
            tags: tags,
            created_at: created_at,
            title: title,
            deeplinks: deeplinks,
            created_by: created_by,
            long_url: long_url,
            client_id: client_id,
            custom_bitlinks: custom_bitlinks,
            link: link,
            id: id,
            references: references
          )
        end
  

        def bitlink_clicks(bitlink:, unit: nil, units: nil, unit_reference: nil, size: nil)
          Bitlink::LinkClick.list(
            client: self,
            bitlink: bitlink,
            unit: unit,
            units: units,
            unit_reference: unit_reference,
            size: size
          )
        end
  

        def organizations
          Organization.list(client: self)
        end
  

        def organization(organization_guid:)
          Organization.fetch(client: self, organization_guid: organization_guid)
        end

        def organization_shorten_counts(organization_guid:)
          Bitly::API::ShortenCounts.by_organization(client: self, organization_guid: organization_guid)
        end
  

        def user
          User.fetch(client: self)
        end
  

        def update_user(name: nil, default_group_guid: nil)
          user = Bitly::API::User.new(client: self, data: {})
          user.update(name: name, default_group_guid: default_group_guid)
        end
  

        def groups(organization_guid: nil)
          Group.list(client: self, organization_guid: organization_guid)
        end
  

        def group(group_guid:)
          Group.fetch(client: self, group_guid: group_guid)
        end
  
    
        def group_shorten_counts(group_guid:)
          Bitly::API::ShortenCounts.by_group(client: self, group_guid: group_guid)
        end
  

        def group_preferences(group_guid:)
          Group::Preferences.fetch(client: self, group_guid: group_guid)
        end
  

        def update_group_preferences(group_guid:, domain_preference:)
          group_preferences = Group::Preferences.new(data: { "group_guid" => group_guid }, client: self)
          group_preferences.update(domain_preference: domain_preference)
        end
  

        def update_group(group_guid:, name: nil, organization_guid: nil, bsds: nil)
          group = Group.new(data: { "guid" => group_guid }, client: self)
          group.update(
            name: name,
            organization_guid: organization_guid,
            bsds: bsds
          )
        end
  

        def group_bitlinks(
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
          Bitlink.list(
            client: self,
            group_guid: group_guid,
            size: size,
            page: page,
            keyword: keyword,
            query: query,
            created_before: created_before,
            created_after: created_after,
            modified_after: modified_after,
            archived: archived,
            deeplinks: deeplinks,
            domain_deeplinks: domain_deeplinks,
            campaign_guid: campaign_guid,
            channel_guid: channel_guid,
            custom_bitlink: custom_bitlink,
            tags: tags,
            encoding_login: encoding_login
          )
        end
  

        def delete_group(group_guid:)
          group = Group.new(data: { "guid" => group_guid }, client: self)
          group.delete
        end

        def group_referring_networks(group_guid:, unit: nil, units: nil, size: nil, unit_reference: nil)
          ClickMetric.list_referring_networks(
            client: self,
            group_guid: group_guid,
            unit: unit,
            units: units,
            unit_reference: unit_reference,
            size: size
          )
        end
  

        def group_countries(group_guid:, unit: nil, units: nil, size: nil, unit_reference: nil)
          ClickMetric.list_countries_by_group(
            client: self,
            group_guid: group_guid,
            unit: unit,
            units: units,
            unit_reference: unit_reference,
            size: size
          )
        end
  

        def bsds
          BSD.list(client: self)
        end
  

        def oauth_app(client_id:)
          OAuthApp.fetch(client: self, client_id: client_id)
        end
  
        private
  
        def default_headers
          {
            "User-Agent" => USER_AGENT,
            "Authorization" => "Bearer #{@token}",
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          }
        end
      end
    end
  end