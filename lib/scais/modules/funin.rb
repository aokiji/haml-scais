class Funin < Block
  attr_writer :formula
  chainable_methods :formula
  
  validates :formula, :presence => true
  validates :outputs, :many => {:maximum => 1}
  
  def initialize code, attributes={}
    super attributes.merge(:code => code, :module => 'FUNIN')
  end
  
  # add constants before validation
  def before_validate
    self.constants={ 'FORMULA' => formula}
    super
  end
end
