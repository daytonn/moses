require 'moses'
require 'fileutils'
require 'active_support/inflector'

class Moses::Application
  include Moses
  commands :create
  attr_reader :root_path

  def initialize(root_path = Dir.getwd)
    @root_path = root_path
  end

  def create
    if @args.first
      @app_name = @args.first
      create_app_dir
      create_help_file
      create_version_file
      create_bin_dir
      create_bin_file
      create_lib_dir
      create_application_class
    else
      output.puts "You need to name your application: moses create myapp"
    end
  end

  private

  def create_app_dir
    FileUtils.mkdir("#{@root_path}/#{@app_name}") unless File.directory?("#{@root_path}/#{@app_name}")
  end

  def create_help_file
    unless File.file?("#{@root_path}/#{@app_name}/HELP.md")
      FileUtils.touch("#{@root_path}/#{@app_name}/HELP.md")
      File.open("#{@root_path}/#{@app_name}/HELP.md", 'w+') do |f|
        f << "Todo: Add your own instructions"
      end
    end
  end

  def create_version_file
    unless File.file?("#{@root_path}/#{@app_name}/VERSION")
      FileUtils.touch("#{@root_path}/#{@app_name}/VERSION")
      File.open("#{@root_path}/#{@app_name}/VERSION", 'w+') do |f|
        f << "0.0.0"
      end
    end
  end

  def create_bin_dir
    FileUtils.mkdir("#{@root_path}/#{@app_name}/bin") unless File.directory?("#{@root_path}/#{@app_name}/bin")
  end

  def create_bin_file
    unless File.file?("#{@root_path}/#{@app_name}/bin/#{@app_name}")
      FileUtils.touch("#{@root_path}/#{@app_name}/bin/#{@app_name}")
      FileUtils.chmod("u+x", "#{@root_path}/#{@app_name}/bin/#{@app_name}")
      File.open("#{@root_path}/#{@app_name}/bin/#{@app_name}", 'w+') do |f|
        f << %Q{#!/usr/bin/env ruby
$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require "#{@app_name}"
#{@app_name.camelize}.new.run
        }
      end
    end
  end

  def create_lib_dir
    FileUtils.mkdir("#{@root_path}/#{@app_name}/lib") unless File.directory?("#{@root_path}/#{@app_name}/lib")
  end

  def create_application_class
    unless File.file?("#{@root_path}/#{@app_name}/lib/#{@app_name}.rb")
      FileUtils.touch("#{@root_path}/#{@app_name}/lib/#{@app_name}.rb")
      File.open("#{@root_path}/#{@app_name}/lib/#{@app_name}.rb", 'w+') do |f|
        f << %Q{require "moses"

class #{@app_name.camelize}
  include Moses
end
        }
      end
    end
  end
end