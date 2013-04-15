module Rdbdocumentor
  module Domain
    class Column
      attr_accessor :name, :comment, :type, :nullable

      def initialize(name = '', comment = '')
        @name = name
        @comment = comment
        @type = ''
        @nullable = true
      end
    end
  end
end