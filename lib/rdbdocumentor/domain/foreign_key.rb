module Rdbdocumentor
  module Domain
    class ForeignKey
      attr_accessor :name, :cols, :match_option, :update_rule, :delete_rule, :referenced_table, :referenced_cols
      def initialize(name = '')
        @name = name
        @cols = []
        @match_option = ''
        @update_rule = ''
        @delete_rule = ''
        @referenced_table = ''
        @referenced_cols = []
      end
    end
  end
end