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
                new(data: response.body, client: client, response: respond)
                    end
                    
