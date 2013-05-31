require 'mysql2'
require 'moira/domain/column'
require 'moira/domain/index'
require 'moira/domain/foreign_key'
require 'moira/domain/unique_key'

module Rdbdocumentor
  module DB
    INFORMATION_SCHEMA = 'information_schema'

    TABLE_SELECT = <<-T_S
            select
              table_name, table_comment
            from tables
            where table_schema = '%s'
            and table_type = 'BASE TABLE'
            order by table_name
    T_S
    COLUMN_SELECT = <<-C_S
            select
              column_name, column_default, is_nullable,
              column_type, data_type,
              character_maximum_length, numeric_precision, numeric_scale,
              column_comment
            from columns
            where table_schema = '%s'
            and table_name = '%s'
            order by table_name, ordinal_position
    C_S
    PRIMARY_KEY_SELECT = <<-P_K_S
            select
              case non_unique when 0 then 'NO' when 1 then 'YES' END as non_unique,index_name, column_name
            from statistics
            where table_schema = '%s'
            and table_name = '%s'
            and index_name = 'PRIMARY'
            order by index_name, seq_in_index
    P_K_S
    UNIQUE_KEY_SELECT = <<-U_K_S
            select
              constraint_name
            from table_constraints tc
            where tc.constraint_schema = '%s'
            and table_name = '%s'
            and constraint_type not in ('PRIMARY KEY', 'FOREIGN KEY')
    U_K_S

    INDEX_SELECT = <<-IX_S
            select
              distinct case non_unique when 0 then 'NO' when 1 then 'YES' END as non_unique,index_name
            from statistics
            where table_schema = '%s'
            and table_name = '%s'
            and index_name <> 'PRIMARY'
            order by index_name
    IX_S
    INDEX_COLUMNS_SELECT = <<-I_C_S
            select
              column_name
            from statistics
            where table_schema = '%s'
            and table_name = '%s'
            and index_name = '%s'
            order by index_name,seq_in_index
    I_C_S
    FOREIGN_KEY_SELECT = <<-FK_S
            select
              constraint_name, match_option,update_rule,delete_rule, table_name,referenced_table_name
            from referential_constraints
            where constraint_schema = '%s'
            and table_name = '%s'
            order by referenced_table_name
    FK_S

    CONSTRAINT_COLUMNS_SELECT = <<-CC_S
            select
              kcu.table_name,kcu.constraint_name,kcu.column_name,kcu.ordinal_position,
              kcu.referenced_table_name,kcu.referenced_column_name,kcu.position_in_unique_constraint
            from table_constraints tc
            join key_column_usage kcu on tc.constraint_name = kcu.constraint_name and tc.constraint_schema = kcu.constraint_schema
            where kcu.constraint_schema = '%s'
            and kcu.constraint_name = '%s'
            and tc.table_name = '%s'
            order by kcu.ordinal_position
    CC_S

    class MysqlInfo
      def initialize(host, username, password, schema, port = 3306)
        begin
          @db = Mysql2::Client.new(:host => host, :username => username, :password => password, :port => port, :database => INFORMATION_SCHEMA)
        rescue => e
          p e
        end

        @schema = schema
      end

      def tables()
        results = []
        @db.query(TABLE_SELECT % @schema).each do |row|
          table = Rdbdocumentor::Domain::Table.new(row['table_name'], row['table_comment'])
          results << table
        end
        results
      end

      def columns(table_name)
        results = []
        @db.query(COLUMN_SELECT % [@schema, table_name]).each do |row|
          column = Rdbdocumentor::Domain::Column.new(row['column_name'], row['column_comment'])
          column.default = row['column_default']
          column.nullable = row['is_nullable']
          column.type = row['column_type'] # mysql extension
          column.char_length = row['character_maximum_length']
          column.num_precision = row['numeric_precition']
          column.num_scale = row['numeric_scale']
          results << column
        end
        results
      end

      def indexes(table_name)
        results = []
        @db.query(INDEX_SELECT % [@schema, table_name]).each do |row|
          index = Rdbdocumentor::Domain::Index.new
          index.name = row['index_name']
          index.non_unique = row['non_unique']
          results << index
          @db.query(INDEX_COLUMNS_SELECT % [@schema, table_name, index.name]).each do |row|
            index.cols << row['column_name']
          end
        end
        results
      end

      def primary_key(table_name)
        result = Rdbdocumentor::Domain::Index.new
        @db.query(PRIMARY_KEY_SELECT % [@schema, table_name]).each do |row|
          result.name = row['index_name']
          result.non_unique = row['non_unique']
          result.cols << row['column_name']
        end
        result
      end

      def unique_keys(table_name)
        results = []
        @db.query(UNIQUE_KEY_SELECT % [@schema, table_name]).each do |row|
          u_key = Rdbdocumentor::Domain::UniqueKey.new
          u_key.name = row['constraint_name']
          @db.query(CONSTRAINT_COLUMNS_SELECT % [@schema, u_key.name, table_name]).each do |row|
            u_key.cols << row['column_name']
          end
          results << u_key
        end
        results
      end

      def foreign_keys(table_name)
        results = []
        @db.query(FOREIGN_KEY_SELECT % [@schema, table_name]).each do |row|
          f_key = Rdbdocumentor::Domain::ForeignKey.new
          f_key.name = row['constraint_name']
          f_key.match_option = row['match_option']
          f_key.update_rule = row['update_rule']
          f_key.delete_rule = row['delete_rule']
          f_key.referenced_table = row['referenced_table_name']
          @db.query(CONSTRAINT_COLUMNS_SELECT % [@schema, f_key.name, table_name]).each do |row|
            f_key.cols << row['column_name']
            f_key.referenced_cols << row['referenced_column_name']
          end

          results << f_key
        end
        results
      end
    end
  end
end
