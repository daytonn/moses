require 'spec_helper'
require 'moses/argument'

describe Moses::Argument do

  it "takes a string" do
    expect { Moses::Argument.new }.to raise_error ArgumentError
  end

  describe "flags" do
    before do
      @short_flag = Moses::Argument.new '-f'
      @long_flag = Moses::Argument.new '--long_flag'
      @non_flag = Moses::Argument.new 'test'
    end

    it "determines if the argument is a flag" do
      expect(@short_flag.flag?).to be_true
      expect(@long_flag.flag?).to be_true

      expect(@non_flag.flag?).to be_false
    end

    it "determines if the argument is a short flag" do
      expect(@short_flag.short_flag?).to be_true

      expect(@long_flag.short_flag?).to be_false
      expect(@non_flag.short_flag?).to be_false
    end

    it "determines if the argument is a long flag" do
      expect(@long_flag.long_flag?).to be_true

      expect(@short_flag.long_flag?).to be_false
      expect(@non_flag.long_flag?).to be_false
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
