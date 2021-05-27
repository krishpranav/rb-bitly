require "oauth2"
require "base64"

module Bitly

    class OAuth
        attr_reader :client_id, :client_secret

        def initialize(client_id:, client_secret:)
            @client_id = client_id
            @client_secret = client_secret
            @client = OAuth2::Client.new(
                client_id,
                client_secret
                :site => 'https://api-ssl.bitly.com',
                :token_url => '/oauth/access_token',
            )
        end