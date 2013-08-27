require 'yaml'

module Moira
  module ConfigLoader
    def read_config(config_file)
      if !File.exists?(config_file)
        error "missing #{config_file}."
        return
      end

      config = YAML.load_file(config_file)

      db_config = OpenStruct.new(config['database'])
      unless config['database'].key?('port')
        db_config.port = 3306
      end
      validate_db_config(db_config)

      output_config = config['output_dir']
      unless config['output_dir']
        output_config = db_config.target_schema
      end
      validate_output_config(output_config)

      return db_config, output_config
    end

    def validate_db_config(config)
      unless config.host
        raise "missing database host"
      end
      unless config.user_id
        raise "missing database user_id"
      end
      unless config.password
        raise "missing database password"
      end
    end

    def validate_output_config(config)
      unless config
        raise "missing output_dir"
      end
    end
  end
end
