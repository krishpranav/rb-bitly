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
            