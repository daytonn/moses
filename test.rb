require 'pry'

module Foo

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def commands(*args)
      class_eval %Q{
        def commands
          @commands ||= #{args}
        end
      }
    end
  end
end

class Bar
  include Foo

  commands :foo, :bar
end

b = Bar.new
puts b.commands