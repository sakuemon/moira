module Moira
  module Domain
    class Table
      attr_accessor :name, :comment, :cols, :primary_key, :unique_keys, :indexes, :foreign_keys

      def initialize(name = '', comment = '')
        @name = name
        @comment = comment
        @cols = []
        @primary_key = nil
        @unique_keys = []
        @indexes = []
        @foreign_keys = []
      end
    end
  end
end
