module Moira
  module Domain
    class UniqueKey
      attr_accessor :name, :cols
      def initialize(name = '')
        @name = name
        @cols = []
      end
    end
  end
end
