require 'moira/html_transformer'

module Rdbdocumentor
  module Outputer
    TOP_FILENAME = 'index.html'
    TABLE_FILENAME = '%s.html'

    class HtmlOutputer
      def initialize(schema, output_path = './')
        @schema = schema
        @output_path = output_path
      end

      def output
        transformer = HtmlTransformer.new()

        index = File.join(@output_path, TOP_FILENAME)
        top = transformer.transform_top(@schema)
        File.write(index, top);

        tables = {}
        @schema.tables.each {|table|
          file = File.join(@output_path, TABLE_FILENAME % table.name)
          File.write(file, transformer.transform_table(@schema, table))
        }
      end
    end
  end
end
