require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Moses do
  before(:all) do
    @output = StringIO.new
    class TestAppClass
      include Moses
      commands :foo, :bar

      def initialize(output)
        @output = output
      end

      def foo
      end
    end
    @app = TestAppClass.new(@output)
  end

  after do
    ARGV.clear
  end

  describe 'output' do
    it "defaults to STDOUT" do
      class TestOutputAppClass
        include Moses
      end
      app = TestOutputAppClass.new
      expect(app.output).to eq($stdout)
    end

    it "defers to class defined output" do
      expect(@app.output).to eq(@output)
    end
  end

  describe 'help' do
    after do
      FileUtils.rm_rf('HELP') if File.exist?('HELP')
      FileUtils.rm_rf('HELP.md') if File.exist?('HELP.md')
    end

    it "has a HELP_FILE constant" do
      expect(Moses::HELP_FILE).to eq('HELP')
    end

    describe "help_file_content" do
      it "returns the contents of the HELP file" do
        File.open('HELP', 'w+') do |f|
          f << 'Content from the HELP file'
        end
        expect(@app.send(:help_file_content)).to eq("Content from the HELP file")
      end

      it "returns the contents of the HELP.md file" do
        File.open('HELP.md', 'w+') do |f|
          f << 'Content from the HELP.md file'
        end
        expect(@app.send(:help_file_content)).to eq("Content from the HELP.md file")
      end
    end

    it "outputs an instruction message when no HELP file is present" do
      @output.should_receive(:puts).with("Include a HELP file in your project or define a help method")
      @app.send(:help)
    end

    it "outputs the contents of the HELP file if present" do
      File.open('HELP', 'w+') do |f|
        f << 'Content from the HELP file'
      end
      @output.should_receive(:puts).with("Content from the HELP file")
      @app.send(:help)
    end

    it "outputs the contents of the HELP.md file if present" do
      File.open('HELP.md', 'w+') do |f|
        f << 'Content from the HELP.md file'
      end
      @output.should_receive(:puts).with("Content from the HELP.md file")
      @app.send(:help)
    end
  end

  describe 'version' do
    after do
      FileUtils.rm_rf('VERSION.test') if File.exist?('VERSION.test')
    end

    it "has a VERSION_FILE constant" do
      expect(Moses::VERSION_FILE).to eq('VERSION')
    end

    describe "version_file_content" do
      it "returns the contents of the VERSION file" do
        module Moses VERSION_FILE = 'VERSION.test'; end
        File.open('VERSION.test', 'w+') do |f|
          f << 'x.x.x'
        end
        expect(@app.send(:version_file_content)).to eq("x.x.x")
      end
    end

    it "outputs an instruction message when no VERSION file is present" do
      module Moses VERSION_FILE = 'VERSION.test'; end
      @output.should_receive(:puts).with("Include a VERSION file in your project or define a version method")
      @app.send(:version)
    end

    it "returns the contents of the VERSION file" do
      module Moses VERSION_FILE = 'VERSION.test'; end
      File.open("VERSION.test", "w+") do |f|
        f << 'x.x.x'
      end
      @output.should_receive(:puts).with("x.x.x")
      @app.send(:version)
    end
  end

  describe "default_command" do
    it "can be set with the class method" do
      class CustomDefaultCommandClass
        include Moses
        default_command :some_command
      end
      @dc_app = CustomDefaultCommandClass.new
      expect(@dc_app.default_command).to eq(:some_command)
    end
  end

  describe 'option commands' do
    it "has default option commands" do
      expect(@app.default_option_commands).to have_key(:h)
      expect(@app.default_option_commands).to have_key(:help)
      expect(@app.default_option_commands).to have_key(:v)
      expect(@app.default_option_commands).to have_key(:version)

      expect(@app.default_option_commands[:h]).to eq(:help)
      expect(@app.default_option_commands[:help]).to eq(:help)
      expect(@app.default_option_commands[:v]).to eq(:version)
      expect(@app.default_option_commands[:version]).to eq(:version)
    end

    it "assigns option commands" do
      class OptionCommandsClass
        include Moses
        option_commands({ foo: :foo, v: :verbose })
      end
      @opt_cmd = OptionCommandsClass.new

      expect(@opt_cmd.option_commands).to have_key(:foo)
      expect(@opt_cmd.option_commands).to have_key(:h)
      expect(@opt_cmd.option_commands).to have_key(:help)
      expect(@opt_cmd.option_commands).to have_key(:v)
      expect(@opt_cmd.option_commands).to have_key(:version)

      expect(@opt_cmd.option_commands[:foo]).to eq(:foo)
      expect(@opt_cmd.option_commands[:h]).to eq(:help)
      expect(@opt_cmd.option_commands[:help]).to eq(:help)
      expect(@opt_cmd.option_commands[:v]).to eq(:verbose)
      expect(@opt_cmd.option_commands[:version]).to eq(:version)
    end

    it "sets the command to the default option command if the default option is set" do
      ARGV = ['-h']
      @app.run
      expect(@app.command).to eq(:help)
    end

    it "sets the command to the option command if the option is set" do
      class OptionCommandsClass
        include Moses
        commands :verbose
        option_commands({ foo: :foo, v: :verbose })
      end
      @opt_cmd = OptionCommandsClass.new
      ARGV = ['-v']
      @opt_cmd.run
      expect(@opt_cmd.command).to eq(:verbose)
    end
  end

  describe "commands" do
    it "returns a an array of whitelisted commands" do
      expect(@app.commands).to include(:foo)
      expect(@app.commands).to include(:bar)
    end
  end

  describe "run" do
    it "creates a local array of the ARGV array" do
      ARGV = ['one', 'two', 'three']
      @app.stub(:parse_command)
      @app.run
      expect(@app.args).to eq(['one', 'two', 'three'])
    end

    describe "command parsing" do
      before do
        ARGV = ['foo']
        @app.run
      end

      it "parses the command" do
        expect(@app.command).to eq(:foo)
      end

      it "removes the command from the args array" do
        expect(@app.args).to eq([])
      end
    end

    describe "option parsing" do
      describe "single dash flag" do
        it "creates a boolean option with single dash flags -f" do
          ARGV = ['foo', '-f']
          @app.run
          expect(@app.options[:f]).to be_true
        end
      end

      describe 'double dash flag' do

        it "removes the flags from the args array" do
          ARGV = ['foo', '--flag', '-f']
          @app.run
          expect(@app.args).to eq([])
        end

        context 'with value' do
          it "creates a variable option" do
            ARGV = ['foo', '--flag', 'value']
            @app.run
            expect(@app.options[:flag]).to eq('value')
          end
        end

        context 'without value' do
          it "creates a boolean option" do
            ARGV = ['foo', '--flag']
            @app.run
            expect(@app.options[:flag]).to be_true
          end
        end
      end
    end

    describe "running commands" do
      it "sends the command if it is in the commands white list" do
        ARGV = ['foo']
        @app.stub(:foo)
        @app.should_receive(:foo)
        @app.run
      end

      it "does not send a command if it is not in the commands white list" do
        ARGV = ['baz']
        @app.should_not_receive(:baz)
        @app.run
      end

      it "does not send a command if the method is not defined" do
        ARGV = ['bar']
        @app.should_not_receive(:bar)
        @app.run
      end

      it "runs any option commands if the option was passed" do
        ARGV = ['-h']
        @app.should_receive(:help)
        @app.run
      end
    end
  end
end