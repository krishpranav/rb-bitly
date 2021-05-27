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
            