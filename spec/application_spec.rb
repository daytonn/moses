require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'moses/application'
require 'pry'

describe Moses::Application do
  let(:tmp_dir) { Dir.mktmpdir }
  let(:app_dir) { File.join(tmp_dir, "test_app") }
  let(:lib_dir) { File.join(app_dir, "lib") }
  let(:bin_dir) { File.join(app_dir, "bin") }
  let(:help_file) { File.join(app_dir, "HELP.md") }
  let(:version_file) { File.join(app_dir, "VERSION") }
  let(:bin_file) { File.join(bin_dir, "test_app") }
  let(:app_class_file) { File.join(lib_dir, "test_app.rb") }
  subject { Moses::Application.new tmp_dir }

  after do
    FileUtils.rm_rf tmp_dir
  end

  describe "initialization" do
    it "has default root_path" do
      subject = Moses::Application.new
      expect(subject.root_path).to eq(File.dirname(File.expand_path('..', __FILE__)))
    end

    it "can be initialized with a root_path" do
      expect(subject.root_path).to eq(tmp_dir)
    end
  end

  describe "create" do
    before do
      subject.instance_variable_set(:@args, ['test_app'])
      subject.create
    end

    it "makes a directory for the application" do
      expect(File.directory?(app_dir)).to be_true
    end

    it "makes a HELP file" do
      expect(File.read(help_file)).to eq(fixture_content("HELP.md"))
    end

    it "makes a version file" do
      expect(File.read(version_file)).to eq(fixture_content("VERSION"))
    end

    it "makes a bin directory" do
      expect(File.directory?(bin_dir)).to be_true
    end

    it "makes an executable file" do
      expect(File.read(bin_file)).to eq(fixture_content("bin_file"))
      expect(File.executable?(bin_file)).to be_true
    end

    it "makes a lib directory" do
      expect(File.directory?(lib_dir)).to be_true
    end

    it "makes an applcation class file" do
      expect(File.read(app_class_file)).to eq(fixture_content("app_class.rb"))
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
