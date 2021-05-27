RSpec.describe Bitly::Error do
    let(:response) { Bitly::HTTP::Response.new(
        status: "404",
        body: {
            message: "Missing",
            description: "The resource could not be found"
        }.to_json,
        headers: {}
    )}