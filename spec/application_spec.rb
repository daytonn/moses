require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'moses/application'
require 'pry'

describe Moses::Application do

  describe "create" do

    before do
      @bin = File.expand_path(File.join("bin", "moses"))
      @tmp_dir = Dir.mktmpdir
      @app = Moses::Application.new @tmp_dir
    end

    after do
      FileUtils.rm_rf @tmp_dir
    end

    describe "initialization" do
      it "has default root_path" do
        app = Moses::Application.new
        expect(app.root_path).to eq(File.dirname(File.expand_path('..', __FILE__)))
      end

      it "can be initialized with a root_path" do
        expect(@app.root_path).to eq(@tmp_dir)
      end
    end

    describe "create" do
      before do
        @app.instance_variable_set(:@args, ['test_app'])
        @app.create
      end

      it "makes a directory for the application" do
        expect(File.directory?("#{@tmp_dir}/test_app")).to be_true
      end

      it "makes a HELP file" do
        expect(File.file?("#{@tmp_dir}/test_app/HELP.md")).to be_true
        expect(File.read("#{@tmp_dir}/test_app/HELP.md")).to eq("Todo: Add your own instructions")
      end

      it "makes a version file" do
        expect(File.file?("#{@tmp_dir}/test_app/VERSION")).to be_true
        expect(File.read("#{@tmp_dir}/test_app/VERSION")).to eq("0.0.0")
      end

      it "makes a bin directory" do
        expect(File.directory?("#{@tmp_dir}/test_app/bin")).to be_true
      end

      it "makes an executable file" do
        expect(File.file?("#{@tmp_dir}/test_app/bin/test_app")).to be_true
        expect(File.executable?("#{@tmp_dir}/test_app/bin/test_app")).to be_true
        expected_content = %Q{
#!/usr/bin/env ruby
$: << File.expand_path(File.join(File.dirname(__FILE__), "../lib"))
require 'test_app'
TestApp.new.run
        }
        expect(File.read("#{@tmp_dir}/test_app/bin/test_app")).to eq(expected_content)
      end

      it "makes a lib directory" do
        expect(File.directory?("#{@tmp_dir}/test_app/lib")).to be_true
      end

      it "makes an applcation class file" do
        expect(File.file?("#{@tmp_dir}/test_app/lib/test_app.rb")).to be_true
        expected_content = %Q{
class TestApp
  include Moses
end
        }
        expect(File.read("#{@tmp_dir}/test_app/lib/test_app.rb")).to eq(expected_content)
      end

      it "warns you if you forget the app name" do
        app = Moses::Application.new
        app.instance_variable_set(:@args, [])
        app.output.stub(:puts)
        app.output.should_receive(:puts).with('You need to name your application: moses create myapp')
        app.create
      end
    end

  end

end