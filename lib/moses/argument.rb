module Moses
  class Argument

    attr_accessor :value

    def initialize(string)
      @string = string
    end

    def to_s
      @value || @string
    end

    def flag?
      @string =~ /^-/ ? true : false
    end

    def short_flag?
      @string =~ /^-{1}[^-]/ ? true : false
    end

    def long_flag?
      @string =~ /^-{2}/ ? true : false
    end

  end
end