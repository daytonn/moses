module Moses
  class Argument < String

    attr_accessor :value

    def initialize(string)
      @value = string
      super(string)
    end

    def to_s
      value
    end

    def flag?
      self =~ /^-/ ? true : false
    end

    def short_flag?
      self =~ /^-{1}[^-]/ ? true : false
    end

    def long_flag?
      self =~ /^-{2}/ ? true : false
    end

    def not_flag?
      !flag?
    end

    def to_sym
      value.gsub(/^-{1,2}/, '').to_sym
    end

  end
end
