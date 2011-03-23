require File.expand_path('../helper',__FILE__)

class TestHamlScais < Test::Unit::TestCase
  def test_block
    puts block 'BF1', :outputs => {"O0" => true}, :constants => {'hi' => 'a < b', 'TIME' => -1}, :initial_variables => {'variable1' => {:initial_value => 10, :alias => 'Yo'}, 'variable2' => {}}
    puts block 'BF2', :inputs => {"O0" => {:alias => 'output', :recursive => true}}
  end
  
  def test_fint
    puts fint 'BF1', :time => (1..10).to_a, :coef => (1..10).to_a
  end
  
  def test_logate
    puts logate 'BL', :low => 'BF1.O0', :high => 'BF2.O0', :condition => 'TIME > 100', :initial_output => 0
  end
end
