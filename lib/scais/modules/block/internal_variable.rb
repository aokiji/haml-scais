class InternalVariable
  include Chainable
  include Attributed
  
  attr_chainable :code, :initial_value, :alias
  
  def initialize code, attributes
    @code = code
    self.attributes = attributes
  end
end
