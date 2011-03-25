class Output
  include Chainable
  attr_chainable :code, :save, :alias, :initial_value, :block, :n
  
  def initialize block, n = nil
    @block = block
    @n = n
    @save = false
  end
  # check is outputs is going to be saved to database
  def save?
    save == true
  end
  
  # 1 if save is true 0 otherwise
  def save_value
    save? ? 1 : 0
  end
  
  # check alias available
  def alias?
    !@alias.nil? && !@alias.empty?
  end
  
  def to_s
    "#{block.code}.#{self.code}"
  end
  
  # check initial_value available
  def initial_value?
    !initial_value.nil?
  end
end
