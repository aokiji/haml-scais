module Scais
  module Helpers
    # Module that defines method for manipulating multiple
    # attributes from a hash
    #
    # Author::    Nicolas De los Santos Cicutto
    module Attributed 
      # get attributes
      def attributes
        @attributes
      end

      # update attributes from hash
      def attributes=(attributes)
        @attributes||= {}
        attributes.each do |key, val| 
          if respond_to?("#{key}=")
            send("#{key}=", val) 
            @attributes[key] = val
          end
        end
      end
    end
    
    # Module that adds method for automatic defining those attributes
    # that when set can be chained
    #    Example : Fint.new('1').name('Block').index(10)
    #
    module Chainable
      module InstanceMethods
        attr_reader :chain_block
      end
      
      module ClassMethods
        # automatic define chainable reader methods
        # is your responsibility to define the setter method attribute=
        def attr_chainable_reader *methods
          methods.each do |m|
            self.class_eval "def #{m.to_s} *args, &block;@chain_block=block;args.empty? ? @#{m.to_s} : (self.#{m.to_s}=*args) && self; end"
          end
        end
        
        # automatic define chainable reader methods and a setter
        def attr_chainable *methods
          methods.each do |m|
            self.class_eval "def #{m.to_s} *args, &block;@chain_block=block;args.empty? ? @#{m.to_s} : (self.#{m.to_s}=*args) && self; end"
            self.class_eval "def #{m.to_s}= value; @#{m.to_s}=value; end"
          end
        end
      end
      
      def self.included( base )
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods 
      end
    end
    
    # Module to help define a common syntax on constants, initial values and
    # internal variables.
    #
    #
    module Builder
      module ClassMethods
        # it receives a list of name methods, or method => constant_name (wich must be the last to be defined)
        #   Example:
        #     constants :formula, :times => :time
        def constants *cons
          renamed = cons.last.is_a?(Hash) ? cons.pop : {}
          cons.each do |c|
            define_constant c, c
          end
          renamed.each do |c, as|
            define_constant c, as
          end
        end
        
        # Defines a list of initial_variables accessors from a list of methods that can include 
        # method => constant_name at the end (in case method an constant name differ)
        def initial_variables *vars
          renamed = vars.last.is_a?(Hash) ? vars.pop : {}
          vars.each do |var|
            define_initial_variable var, var
          end
          renamed.each do |var, as|
            define_initial_variable var, as
          end
        end
        
        # Defines a list of internal_variables accessors from a list of methods that can include 
        # method => constant_name at the end (in case method an constant name differ)
        def internal_variables *vars
          renamed = vars.last.is_a?(Hash) ? vars.pop : {}
          vars.each do |var|
            define_internal_variable var, var
          end
          renamed.each do |var, as|
            define_internal_variable var, as
          end
        end
        
        private
        # defines accessors for a constant given the method name(c) and the constant name (as)
        def define_constant c, as
          self.attr_chainable c
          self.class_eval "def #{c.to_s}= value; unless value.nil?; self.constants.delete_if{|x| x.code == '#{codify(as)}'}; self.constants<< Constant.new('#{codify(as)}', value); @#{c.to_s}=value; end; end"
        end
        
        def define_initial_variable var, as
          self.attr_chainable var
          self.class_eval "def #{var.to_s}= *args; unless args.empty?; self.initial_variables.delete_if{|x| x.code == '#{codify(as)}'}; args=['#{codify(as)}']+args.flatten;self.initial_variables<< InitialVariable.new(*args);end;end"
        end
        
        def define_internal_variable var, as
          self.attr_chainable var
          self.class_eval "def #{var.to_s}= *args; unless args.empty?; self.internal_variables.delete_if{|x| x.code == '#{codify(as)}'}; args=['#{codify(as)}']+args.flatten;self.internal_variables<< InternalVariable.new(*args);end;end"
        end
        
        def codify s
          s.to_s.gsub(/_/,'').upcase
        end
      end
      
      def self.included( base )
        base.send :extend, ClassMethods 
      end
    end
    
    
  end
end
