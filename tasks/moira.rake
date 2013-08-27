require 'fileutils'

require 'moira/config_loader'
require 'moira/db_info_reader'
require 'moira/html_outputer'

include Moira::ConfigLoader

namespace :moira do
  desc 'generate schema infomation'
  task :gen,:config do |t, args|
    if args.config.nil?
      exit
    end
    db_config, output_config = read_config(args.config)
    schema = Moira::DBInfoReader.new(db_config.host, db_config.user_id, db_config.password, db_config.target_schema, db_config.port).read_schema


    outputer = Moira::Outputer::HtmlOutputer.new(schema, output_config)
    outputer.output

    FileUtils.cp File.join(File.expand_path('../../lib/moira/template', __FILE__), 'main.css'), File.join(output_config, 'main.css')
  end
end
