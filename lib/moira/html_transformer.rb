require 'erubis'

module Rdbdocumentor
  class HtmlTransformer

    def transform_top(schema)
        erb = Erubis::Eruby.new(read_template('index.html.erb'))
        erb.result(:schema => schema)
    end

    def transform_table(schema, table)
        erb = Erubis::Eruby.new(read_template('table.html.erb'))
        erb.result(:schema => schema, :table => table)
    end

    def get_template_path
      File.expand_path('../template', __FILE__)
    end

    def read_template(filename)
      template_dir = get_template_path()
      file = File.join(template_dir, filename)
      File.read(file, :encoding => Encoding::UTF_8)
    end
  end
end
