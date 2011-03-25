class Input
  attr_accessor :code, :recursive, :from, :accelerator
  attr_reader :modes
  
  def initialize
    @recursive = false
  end
  
  # check if recursive
  def recursive?
    recursive == true
  end
  
  # 1 if recursive true 0 otherwise
  def recursive_value
    recursive? ? 1 : 0
  end
  
  # set modes for block. accepts Array and String.
  # if Array provided if extends instance to_s method to print separated by ',' elements
  def modes= m
    m.instance_eval "def to_s; self.join(','); end" if m.is_a?(Array) #override to_s
    @modes = m
  end
  
  # check if modes given
  def modes?
    !@modes.nil? && !@modes.empty?
  end
end
