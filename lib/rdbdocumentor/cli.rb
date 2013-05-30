require 'rdbdocumentor'
require 'rdbdocumentor/config_loader'
require 'rdbdocumentor/html_outputer'
require 'rdbdocumentor/db/mysql_info'
require 'rdbdocumentor/domain/schema'
require 'rdbdocumentor/domain/table'
require 'rdbdocumentor/domain/column'
require 'thor'
require 'yaml'
require 'ostruct'

module Rdbdocumentor
  class Cli < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    include Thor::Actions
    include Rdbdocumentor::ConfigLoader

    class_option :verbose, :type => :boolean, :default => false

    desc "output", "output task"
    option :config, :type => :string, :default => 'rdbdoc.yml'
    def output()
      # read config file.
      begin
        db_config,output_config = read_config(options[:config])
      rescue => e
        error e.message
        exit 1
      end

      # read database info.
      db_info = Rdbdocumentor::DB::MysqlInfo.new(db_config.host, db_config.user_id, db_config.password, db_config.target_schema, db_config.port)
      schema = Rdbdocumentor::Domain::Schema.new(db_config.target_schema)
      schema.tables = db_info.tables;
      schema.tables.each {|table|
        table.cols = db_info.columns(table.name)
        table.primary_key = db_info.primary_key(table.name)
        table.unique_keys = db_info.unique_keys(table.name)
        table.indexes = db_info.indexes(table.name)
        table.foreign_keys = db_info.foreign_keys(table.name)
      }

      outputer = Rdbdocumentor::Outputer::HtmlOutputer.new(schema, output_config)
      outputer.output

      # setup output dir.
      empty_directory output_config

      copy_file File.join(File.expand_path('../template', __FILE__), 'main.css'), File.join(output_config, 'main.css')

    end

    desc "dryrun", "dry run"
    def dryrun()
      # test output directory.
      # test connect database.
    end

    default_task :output

    def self.source_root
      File.dirname(__FILE__)
    end

    private
  end
end
