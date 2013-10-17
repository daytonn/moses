require 'spec_helper'
require 'moses/argument'

describe Moses::Argument do

  it "takes a string" do
    expect { Moses::Argument.new }.to raise_error ArgumentError
  end

  describe "flags" do
    let(:short_flag) { Moses::Argument.new '-f' }
    let(:long_flag) { Moses::Argument.new '--long_flag' }
    let(:non_flag) { Moses::Argument.new 'test' }

    it "determines if the argument is a flag" do
      expect(short_flag).to be_flag
      expect(long_flag).to be_flag
      expect(non_flag).not_to be_flag
    end

    it "determines if the argument is a short flag" do
      expect(short_flag).to be_short_flag

      expect(long_flag).not_to be_short_flag
      expect(non_flag).not_to be_short_flag
    end

    it "determines if the argument is a long flag" do
      expect(long_flag).to be_long_flag

      expect(short_flag).not_to be_long_flag
      expect(non_flag).not_to be_long_flag
    end

    it "determine if the argument is not a flag" do
      expect(long_flag).not_to be_not_flag
      expect(short_flag).not_to be_not_flag
      expect(non_flag).to be_not_flag
    end

    describe "to_sym" do
      it "removes the dashes prepending flags" do
        expect(short_flag.to_sym).to eq(:f)
        expect(long_flag.to_sym).to eq(:long_flag)
      end

      it "converts plain args to symbol" do
        expect(non_flag.to_sym).to eq(:test)
      end
    end
  end

  describe "value" do
    before do
      @arg = Moses::Argument.new 'test'
    end

    it "can be assigned a value" do
      @arg.value = 'foo'
      expect(@arg.value).to eq('foo')
    end
  end

  describe "to_s" do
    before do
      @arg = Moses::Argument.new 'test'
    end

    it "renders the original string if there is no value" do
      expect(@arg.to_s).to eq('test')
    end

    it "renders the value when set" do
      @arg.value = 'foo'
      expect(@arg.to_s).to eq('foo')
    end
  end

end
