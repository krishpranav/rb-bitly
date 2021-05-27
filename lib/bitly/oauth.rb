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

        def authorize_uri(redirect_uri, state: nil)
            params = {
                redirect_uri: redirect_uri,
                client_id: client_id
            }
            params[:state] = state if state
            @client.authorize_uri(**params).gsub(/api-ssl\./,'')
        end

        def access_token(redirect_uri: nil, code: nil, username: nil, password: nil)
            begin
                if redirect_uri && code
                    access_token_from_code(redirect_uri: redirect_uri, code: code)
                elsif username && password
                    access_token_from_credentials(username: username, password: password)
                else
                    raise ArgumentError, "not enough arguments, please include a redirect uri and code or a username and password."
                end
            rescue OAuth2::Error => e
                raise Bitly::Error, Bitly::HTTP::Response.new(status: e.response.status.to_s, body: e.response.body, headers: e.response.headers)
            end
        end

        private 

        def access_token_from_code(redirect_uri:, code:)
            @client.get_token(
                redirect_uri: redirect_uri,
                code: code
            ).token
        end
        