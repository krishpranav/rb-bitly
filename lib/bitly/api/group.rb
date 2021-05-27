require_relative "./base"
require_relative "./list"

module Bitly
    module API

        class Group 
            autoload :Preferences, File.join(File.dirname(__FILE__), "group/preference.rb")

            include Base

            class List < Bitly::API::List ; end

            def self.list(client:, organization_guid: nil)
                params = { "organization_guid" => organization_guid}
                response = client.request(path: "/groups", params: params)
                groups = response.body["groups"].map do |group|
                    Group.new(data: group, client: client)
                end
                List.new(items: groups, response: response)
            end
            