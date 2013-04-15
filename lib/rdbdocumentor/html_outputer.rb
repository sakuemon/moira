require 'rdbdocumentor/html_transformer'

module Rdbdocumentor
  module Outputer
    TOP_FILENAME = 'index.html'
    TABLE_FILENAME = '%s.html'

    class HtmlOutputer
      def initialize(schema, output_path = './')
        @schema = schema
      end

      def output
        transformer = HtmlTransformer.new()

        top = transformer.transform_top(schema)
        tables = []
        schema.tables.each {|table|
          tables << transformer.transform_table(schema, table)
        }
      end
    end
  end
end