$: << File.join(File.expand_path('../..', __FILE__), 'lib')

require "moses/argument"
require "moses/arguments"

module Moses

  VERSION_FILE = 'VERSION'
  HELP_FILE = 'HELP'

  attr_reader :args, :command, :options, :default_command
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
          @default_command ||= :#{cmd}
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
  end

  def output
    @output ||= $stdout
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
    @args = Moses::Arguments.new
    parse_options
    parse_command
    set_option_command

    if valid_command?
      self.send(@command)
    else
      self.send(@default_command || :help)
    end
  end

  private

  def parse_options
    args.each do |arg|
      @options[arg.to_sym] = args.get_variable(arg) if arg.flag?
    end
  end

  def parse_command
    @command = args.shift.to_sym if args.first && non_default_command?
  end

  def set_option_command
    @options.each do |opt, v|
      return @command = option_commands[opt] if has_option_command?(opt)
      return @command = default_option_commands[opt] if default_option_commands[opt]
    end
  end

  def default_command?
    default_command && args.first == default_command
  end

  def non_default_command?
    !default_command?
  end

  def valid_command?
    @command && default_commands.include?(@command) || has_command?(@command)
  end

  def has_commands?
    self.class.method_defined?(:commands)
  end

  def has_command?(command)
    has_commands? && [*commands].include?(command) && command_defined?(@command)
  end

  def command_defined?(commant)
    self.class.method_defined?(command)
  end

  def has_option_commands?
    self.class.method_defined?(:option_commands)
  end

  def has_option_command?(command)
    has_option_commands? && !!option_commands[command]
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
