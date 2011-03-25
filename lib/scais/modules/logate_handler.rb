class LogateHandler < Block
  attr_chainable :formula, :action, :limit_conditions, :precision, :previous_output
  attr_writer :initial_output
  
  validates :outputs, :many => {:exact => 1}
  
  def initialize code, attributes={}
    super code, attributes.merge(:module => 'FUNIN')
  end
  
  def initial_output *args
    args.empty? ? @initial_output : (@initial_output = args) && self 
  end
  
  # add constants before validation
  def before_validate
    [:formula, :action, :limit_conditions, :precision].each do |attribute|
      value = self.send(attribute)
      self.constants<< Constant.new(attribute.to_s.gsub(/_/,'').upcase, value) unless value.nil?
    end
    args= ['INITIALOUTPUT']+@initial_output
    self.initial_variables<< InitialVariable.new(*args) unless self.initial_output.nil?
    self.internal_variables<< InternalVariable.new('PREVIOUSOUTPUT', self.previous_output)
    self.outputs<< output(0) if self.outputs.empty?
    super
  end
end
