module Rdbdocumentor
  module Domain
    class Column
      attr_accessor :name, :comment, :type, :nullable, :default, :char_length, :num_precision, :num_scale

      char_types = ['char', 'varchar']
      date_types = []

      def initialize(name = '', comment = '')
        @name = name
        @comment = comment
        @default = ''
        @nullable = true
        @type = ''
        @char_length = 0
        @num_precision = 0
        @num_scale = 0
      end

    end
  end
end
