module Moira
  module Domain
    class Index
      attr_accessor :name, :non_unique, :cols

      def initialize(name = '')
        @name = name
        @non_unique = false
        @cols = []
      end
    end
  end
end
