require "moses"
require "fileutils"
require "erb"
require "active_support/inflector"

class Moses::Application
  include Moses
  commands :create
  attr_reader :root_path, :app_name

  def initialize(root_path = Dir.getwd)
    @root_path = root_path
  end

  def create
    if @app_name = args.first
      create_app_dir
      create_bin_dir
      create_lib_dir
      create_help_file
      create_version_file
      create_bin_file
      create_application_class
    else
      output.puts "You need to name your application: moses create myapp"
    end
  end

  private

  def create_app_dir
    create_directory(app_dir)
  end

  def create_bin_dir
    create_directory(bin_dir)
  end

  def create_lib_dir
    FileUtils.mkdir(lib_dir) unless File.directory?(lib_dir)
  end

  def create_help_file
    copy_template("HELP.md", help_file)
  end

  def create_version_file
    copy_template("VERSION", version_file)
  end

  def create_bin_file
    unless File.file?(bin_file)
      bin_template = ERB.new(File.read(template("bin_file.erb")))
      File.open(bin_file, "w+") { |f| f << bin_template.result(binding) }
      FileUtils.chmod("u+x", bin_file)
    end
  end

  def create_application_class
    unless File.file?(app_class_file)
      class_template = ERB.new(File.read(template("app_class.erb")))
      File.open(app_class_file, 'w+') { |f| f << class_template.result(binding) }
    end
  end

  def app_dir
    File.join(root_path, app_name)
  end

  def bin_dir
    File.join(app_dir, "bin")
  end

  def lib_dir
    File.join(app_dir, "lib")
  end

  def help_file
    File.join(app_dir, "HELP.md")
  end

  def version_file
    File.join(app_dir, "VERSION")
  end

  def bin_file
    File.join(bin_dir, app_name)
  end

  def app_class_file
    File.join(lib_dir, "#{app_name}.rb")
  end

  def template(filename)
    File.join(File.dirname(File.expand_path("../..", __FILE__)), "templates", filename)
  end

  def copy_template(src, dest)
    FileUtils.cp(template(src), dest) unless File.file?(dest)
  end

  def create_directory(dir)
    FileUtils.mkdir(dir) unless File.directory?(dir)
  end
end
