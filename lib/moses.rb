module Moses

  VERSION_FILE = 'VERSION'
  HELP_FILE = 'HELP'

  attr_reader :args, :command, :options
  attr :default_option_commands, :default_commands

  module ClassMethods
    def commands(*args)
      class_eval %Q{
        def commands
          @commands ||= #{args}
        end
      }
    end

    def default_command(cmd)
      class_eval %Q{
        def default_command
          @default_command ||= "#{cmd}".to_sym
        end
      }
    end

    def option_commands(option_cmds)
      class_eval %Q{
        def option_commands
          @option_commands ||= default_option_commands.merge(#{option_cmds})
        end
      }
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    class_eval %Q{
      def output
        @output ||= $stdout
      end
    }
  end

  def default_commands
    @default_commands ||= [:help, :version]
  end

  def default_option_commands
    @default_option_commands ||= {
      h: :help,
      help: :help,
      version: :version,
      v: :version
    }
  end

  def run
    @options = {}
    @args = Array.try_convert ARGV
    parse_options
    parse_command
    set_option_command

    self.send(@command) if valid_command?
    self.send(default_command || :help) if @command.nil?
  end

  private

  def parse_options
    @args.each_with_index do |arg, index|
      if flag?(arg)
        next_index = index + 1
        if variable_option? index
          create_variable_option(arg, next_index)
        else
          create_boolean_option(arg)
        end
      end
    end
    @args.delete_if { |a| flag?(a) }
  end

  def parse_command
    @command = @args.shift.to_sym if @args.first && @args.first.respond_to?(:to_sym)
  end

  def set_option_command
    @options.each do |opt, v|
      if self.class.method_defined?(:option_commands) && option_commands[opt]
        @command = option_commands[opt]
        return
      end

      if default_option_commands[opt]
        @command = default_option_commands[opt]
        return
      end
    end
  end

  def valid_command?
    default_commands.include?(@command) || self.class.method_defined?(:commands) && [*commands].include?(@command) && self.class.method_defined?(@command)
  end

  def create_variable_option(flag, next_index)
    key = flag.gsub(/^--/, '').to_sym
    if not_flag? @args[next_index]
      value = @args[next_index]
      @args.delete_at next_index
    end

    @options[key] = value || true
  end

  def create_boolean_option(flag)
    key = flag.gsub(/^-{1,2}/, '').to_sym
    @options[key] = true
  end

  def flag?(arg)
    arg =~ /^-/
  end

  def long_flag?(arg)
    arg =~ /^-{2}/
  end

  def not_flag?(arg)
    arg =~ /^[^-]/
  end

  def variable_option?(i)
    arg = @args[i]
    next_arg = @args[i+1]
    long_flag?(arg) && next_arg && not_flag?(next_arg)
  end

  def help
    output.puts help_file_content || "Include a HELP file in your project or define a help method"
  end

  def help_file_content
    content = File.read(File.expand_path(Moses::HELP_FILE)) if File.exist?(File.expand_path(Moses::HELP_FILE))
    content = File.read(File.expand_path("#{Moses::HELP_FILE}.md")) if File.exist?(File.expand_path("#{Moses::HELP_FILE}.md"))
    content
  end

  def version
    output.puts version_file_content || "Include a VERSION file in your project or define a version method"
  end

  def version_file_content
    content = File.read(File.expand_path(Moses::VERSION_FILE)) if File.exist?(File.expand_path(Moses::VERSION_FILE))
    content
  end

end