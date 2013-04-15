module FakeFS
  class Dir
    include Enumerable

    def self._check_for_valid_file(path)
      raise Errno::ENOENT, "No such file or directory - #{path}" unless FileSystem.find(path)
    end

    def initialize(string)
      self.class._check_for_valid_file(string)

      @path = string
      @open = true
      @pointer = 0
      @contents = [ '.', '..', ] + FileSystem.find(@path).entries
    end

    def close
      @open = false
      @pointer = nil
      @contents = nil
      nil
    end

    def each(&block)
      while f = read
        yield f
      end
    end

    def path
      @path
    end

    def pos
      @pointer
    end

    def pos=(integer)
      @pointer = integer
    end

    def read
      raise IOError, "closed directory" if @pointer == nil
      n = @contents[@pointer]
      @pointer += 1
      n.to_s.gsub(path + '/', '') if n
    end

    def rewind
      @pointer = 0
    end

    def seek(integer)
      raise IOError, "closed directory" if @pointer == nil
      @pointer = integer
      @contents[integer]
    end

    def self.[](*pattern)
      glob pattern
    end

    def self.exists?(path)
      File.exists?(path) && File.directory?(path)
    end

    def self.chdir(dir, &blk)
      FileSystem.chdir(dir, &blk)
    end

    def self.chroot(string)
      raise NotImplementedError
    end

    def self.delete(string)
      _check_for_valid_file(string)
      raise Errno::ENOTEMPTY, "Directory not empty - #{string}" unless FileSystem.find(string).empty?

      FileSystem.delete(string)
    end

    def self.entries(dirname)
      _check_for_valid_file(dirname)

      Dir.new(dirname).map { |file| File.basename(file) }
    end

    def self.foreach(dirname, &block)
      Dir.open(dirname) { |file| yield file }
    end

    def self.glob(pattern, &block)
      matches_for_pattern = lambda do |matcher|
        [FileSystem.find(matcher) || []].flatten.map{|e|
          Dir.pwd.match(%r[\A/?\z]) || !e.to_s.match(%r[\A#{Dir.pwd}/?]) ? e.to_s : e.to_s.match(%r[\A#{Dir.pwd}/?]).post_match}.sort
      end

      if pattern.is_a? Array
        files = pattern.collect { |matcher| matches_for_pattern.call matcher }.flatten
      else
        files = matches_for_pattern.call pattern
      end
      return block_given? ? files.each { |file| block.call(file) } : files
    end

    if RUBY_VERSION >= "1.9"
      def self.home(user = nil)
        RealDir.home(user)
      end
    end

    def self.mkdir(string, integer = 0)
      FileUtils.mkdir(string)
    end

    def self.open(string, &block)
      if block_given?
        Dir.new(string).each { |file| yield(file) }
      else
        Dir.new(string)
      end
    end

    def self.tmpdir
      '/tmp'
    end

    def self.pwd
      FileSystem.current_dir.to_s
    end

    # This code has been borrowed from Rubinius
    def self.mktmpdir(prefix_suffix = nil, tmpdir = nil)
      case prefix_suffix
      when nil
        prefix = "d"
        suffix = ""
      when String
        prefix = prefix_suffix
        suffix = ""
      when Array
        prefix = prefix_suffix[0]
        suffix = prefix_suffix[1]
      else
        raise ArgumentError, "unexpected prefix_suffix: #{prefix_suffix.inspect}"
      end

      t = Time.now.strftime("%Y%m%d")
      n = nil

      begin
        path = "#{tmpdir}/#{prefix}#{t}-#{$$}-#{rand(0x100000000).to_s(36)}"
        path << "-#{n}" if n
        path << suffix
        mkdir(path, 0700)
      rescue Errno::EEXIST
        n ||= 0
        n += 1
        retry
      end

      if block_given?
        begin
          yield path
        ensure
          require 'fileutils'
          # This here was using FileUtils.remove_entry_secure instead of just
          # .rm_r. However, the security concerns that apply to
          # .rm_r/.remove_entry_secure shouldn't apply to a test fake
          # filesystem. :^)
          FileUtils.rm_r path
        end
      else
        path
      end
    end

    class << self
      alias_method :getwd, :pwd
      alias_method :rmdir, :delete
      alias_method :unlink, :delete
    end
  end
end
