module Rdbdocumentor
  module Domain
    class Schema
      attr_accessor :name, :tables

      def initialize(name =  '')
        @name = name
        @tables = []
      end

    end
  end
end