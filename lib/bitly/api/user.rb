require_relative "./base"

module Bitly
  module API

    class User
      class Email
        attr_reader :email, :is_verified, :is_primary
        def initialize(data)
          @email = data["email"]
          @is_verified = data["is_verified"]
          @is_primary = data["is_primary"]
        end
      end

      include Base

      def self.fetch(client:)
        response = client.request(path: "/user")
        new(data: response.body, client: client, response: response)
      end


      def self.attributes
        [:login, :is_active, :is_2fa_enabled, :name, :is_sso_user, :default_group_guid]
      end
    
      def self.time_attributes
        [:created, :modified]
      end

      attr_reader(*(attributes + time_attributes))
      attr_reader :emails

      
      def initialize(data:, client:, response: nil)
        assign_attributes(data)
        @client = client
        @response = response
        if data["emails"]
          @emails = data["emails"].map { |e| Email.new(e) }
        end
      end

      def default_group
        @default_group ||= Group.fetch(client: @client, guid: default_group_guid)
      end

      def update(name: nil, default_group_guid: nil)
        params = { "name" => name }
        if default_group_guid
          params["default_group_guid"] = default_group_guid
          @default_group = nil
        end
        @response = @client.request(
          path: "/user",
          method: "PATCH",
          params: params
        )
        assign_attributes(@response.body)
        self
      end
    end
  end
end