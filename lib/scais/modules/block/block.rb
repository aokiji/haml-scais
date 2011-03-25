class Block 
  include Chainable
  include Validations
  include Attributed
  include Renderer
  
  attr_accessor :module, :code, :name, :active, :outputs, :inputs, :initial_variables, :internal_variables, :debug
  attr_reader :modes, :constants
  attr_chainable :index # make index chainable
  
  validates :code, :name, :index, :active, :debug , :presence => true
  
  def initialize attributes={}
    attributes = {:outputs => OutputArray.new(self),
      :inputs => InputArray.new(self),
      :constants => Array.new,
      :initial_variables => Array.new,
      :internal_variables => Array.new
    }.merge(attributes)
    self.attributes = attributes
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
  
  # check if active
  def active?
    active == true
  end
  
  def active_value
    active? ? 1 : 0
  end
  
  # constant is set by hash
  def constants= hash
    @constants = Array.new
    hash.each do |code, value|
      @constants<< Constant.new(code, value)
    end
  end
  
  # Method that render xml for the block, but first it
  # runs defined validations and before_validate method
  def to_xml
    before_validate
    validate
    render File.expand_path('../../haml/block.haml', __FILE__), self
  end
  
  def to_s
    s="#{self.class.name}"
    s << ":'#{code}'" unless code.nil?
  end
  
  # Get output n for this block
  def output(n)
    Output.new(self, n).code("O#{n}")
  end
  
  private
  # set defaults values when values not given
  def before_validate
    self.active = true if self.active.nil?
    self.name = code if self.name.nil?
    self.debug = 0 if self.debug.nil?
  end
end
