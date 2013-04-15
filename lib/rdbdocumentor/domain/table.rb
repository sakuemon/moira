module Rdbdocumentor
  module Domain
    class Table
      attr_accessor :name, :comment, :cols

      def initialize(name = '', comment = '')
        @name = name
        @comment = comment
        @cols = []
      end
    end
  end
end