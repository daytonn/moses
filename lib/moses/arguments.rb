class Moses::Arguments < Array
  attr_reader :variables

  def initialize
    @variables = {}
    super(args)
  end

  def has_variable?(arg)
    return true if variables[arg]
    next_index = self.index(arg) + 1
    next_arg = self[next_index]
    #TODO: remove long_flag? check for short flag compatibility
    arg.long_flag? && next_arg && next_arg.not_flag?
  end

  def get_variable(arg)
    return variables[arg] if variables[arg]
    if has_variable?(arg) || arg.flag?
      next_arg = self[self.index(arg) + 1]
      value = next_arg || true
      @variables[arg] ||= value
      self.delete_at(self.index(next_arg)) if next_arg
      self.delete_at self.index(arg)
      variables[arg]
    end
  end

  private

  def args
    Array.try_convert(ARGV).map { |arg| Moses::Argument.new(arg) }
  end
end
