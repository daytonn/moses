require 'spec_helper'
require 'moses/arguments'

describe Moses::Arguments do
  before do
    stub_const("ARGV", ["-f", "--long-flag", "test"])
  end

  subject { Moses::Arguments.new }

  it "creates an array of arguments" do
    expect(subject.first).to be_flag
    expect(subject.first).to be_short_flag
    expect(subject[1]).to be_flag
    expect(subject[1]).to be_long_flag
    expect(subject.last).not_to be_flag
  end

  describe "has_variable?" do
    it "returns true if the next argument exists and is not a flag" do
      expect(subject.has_variable?(subject[1])).to be_true
    end

    it "returns false if the argument is not a flag" do
      expect(subject.has_variable?(subject.last)).to be_false
    end
  end

  describe "get_variable" do
    it "returns the next argument" do
      expect(subject.get_variable(subject[1])).to eq("test")
    end

    it "removes the variable from the arguments" do
      subject.get_variable(subject[1])
      expect(subject.last).not_to include("--long-flag")
    end

    it "caches the variable value" do
      flag = subject[1].to_s
      subject.get_variable(subject[1])
      expect(subject).not_to include("--long-flag")
      expect(subject.get_variable(flag)).to eq("test")
    end

    it "returns true if there is no value" do
      expect(subject.get_variable(subject.first)).to be_true
    end
  end
end
