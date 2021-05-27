RSpec.desribe Bitly::API::Base do
    let(:klass) do
        Class.new do
            include Bitly::API::Base
            attr_reader :name, :created_at
            def self.attributes ; [:name] ; end
            def self.time_attributes ; [:created_at] ; end
            def initialize(opts)
                assign_attributes(opts)
            end
        end
    end
    