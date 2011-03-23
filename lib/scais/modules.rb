require 'scais/extensions'
module Scais
  module Modules
    include Scais::Extensions
    attr_accessor :nblocks
    
    #
    # FUNIN BLOCK GENERATOR
    #
    def funin code, options={}
      raise Exception.new('missing formula') if options[:formula].nil?
      options.merge! :constants => {'FORMULA' => options[:formula]}
      options = default_block_options(:outputs => ['O0'], :name => code).merge(options).merge(:module_type => 'FUNIN')
      block code, options
    end
    #
    # FINT BLOCK GENERATOR
    #
    def fint code, options={}
      raise Exception.new('missing time') if options[:time].nil?
      raise Exception.new('missing coef') if options[:coef].nil?
      options.merge! :constants => {'TIME' => options[:time], 'COEF' => options[:coef]}
      options = default_block_options(:outputs => ['O0'], :name => code).merge(options).merge(:module_type => 'FINT')
      block code, options
    end
    
    def block code, options={}
      options = default_block_options.merge options
      options[:code] = code
      nblocks = options[:index].to_i if options[:index]
      self.nblocks+=1
      render File.expand_path('../modules/block.haml', __FILE__), :options => options
    end
    
    def accelerator code, threshold, options={}
      render File.expand_path('../modules/accelerator.haml', __FILE__), :code => code, :threshold => threshold, :options => options
    end
    
    def nblocks
      @nblocks||= 1
    end
    
    private 
    def default_block_options options={}
      { :active => 1 , :debugging_level => 0 , :index => nblocks, :modes => 'ALL',
        :outputs => [], :inputs => [], :constants => []}.merge options
    end
  end
end
