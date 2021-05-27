require_relative "./base"
require_relative "./list"

module Bitly
    module API

        class Group 
            autoload :Preferences, File.join(File.dirname(__FILE__), "group/preference.rb")

            include Base

            class List < Bitly::API::List ; end