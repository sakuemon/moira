require 'moira'
require 'moira/config_loader'
require 'moira/html_outputer'
# require 'moira/db/mysql_info'
require 'moira/db_info_reader'
# require 'moira/domain/schema'
# require 'moira/domain/table'
# require 'moira/domain/column'
require 'thor'
require 'yaml'
require 'ostruct'

module Moira
  class Cli < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    include Thor::Actions
    include Moira::ConfigLoader

    class_option :verbose, :type => :boolean, :default => false

    desc "output", "output task"
    option :config, :type => :string, :default => 'moira.yml'
    def output()
      # read config file.
      db_config,output_config = read_config(options[:config])

      # read database info.
      schema = Moira::DBInfoReader.new(db_config.host, db_config.user_id, db_config.password, db_config.target_schema, db_config.port).read_schema


      outputer = Moira::Outputer::HtmlOutputer.new(schema, output_config)
      outputer.output

      # setup output dir.
      empty_directory output_config

      copy_file File.join(File.expand_path('../template', __FILE__), 'main.css'), File.join(output_config, 'main.css')

    end

    default_task :output

    def self.source_root
      File.dirname(__FILE__)
    end

    private
  end
end
