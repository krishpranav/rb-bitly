RSpec.describe Bitly::Error do
    let(:response) { Bitly::HTTP::Response.new(
        status: "404",
        body: {
            message: "Missing",
            description: "The resource could not be found"
        }.to_json,
        headers: {}
    )}

    it "is initialised with a Bitly::HTTP::Response" do
        expect { Bitly::Error.new}.to raise_error(ArgumentError)
        expect { Bitly::Error.new(response) }.not_to raise_error
    end

    describe "with an error" do
        let(:error) { Bitly::Error.new(response)}

        it "returns the original response" do
            expect(error.response).to eq(response)
        end
        