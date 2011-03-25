class InternalVariable
  attr_accessor :code, :initial_value, :alias
  
  def initialize code
    @code = code
  end
end
