require 'moira/db/mysql_info'
require 'moira/domain/schema'
require 'moira/domain/table'
require 'moira/domain/column'

module Moira
  class DBInfoReader
    def initialize(host, user_id, password, target_schema, port)
      @host = host
      @user_id = user_id
      @password = password
      @target_schema = target_schema
      @port = port
    end

    def read_schema
      db_info = Moira::DB::MysqlInfo.new(@host, @user_id, @password, @target_schema, @port)
      schema = Moira::Domain::Schema.new(@target_schema)
      schema.tables = db_info.tables;
      schema.tables.each {|table|
        table.cols = db_info.columns(table.name)
        table.primary_key = db_info.primary_key(table.name)
        table.unique_keys = db_info.unique_keys(table.name)
        table.indexes = db_info.indexes(table.name)
        table.foreign_keys = db_info.foreign_keys(table.name)
      }
      return schema
    end
  end
end