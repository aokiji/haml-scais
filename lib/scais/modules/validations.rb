require 'scais/modules/validations/presence_validator'
require 'scais/modules/validations/many_validator'

module Validations
  module InstanceMethods
    attr_writer :errors
    
    def errors
      @errors ||= Array.new
    end
    
    def validate
      self.class.validations.each do |key, options|
        begin
          validator = eval("Validations::#{key.to_s.capitalize}Validator")
        rescue NameError
          raise ArgumentError, "Unknown validator: '#{key}'"
        end
        options.each do |attribute, opts|
          validator.new.validate(self, attribute, opts)
        end
      end
      raise Exception.new("Errors in #{self.to_s} -- #{errors.inspect}") unless self.errors.empty?
    end
  end
  
  module ClassMethods
    attr_writer :validations
    
    def validations
      @validations||= {}
    end
       
    def validates(*attributes)
      defaults = attributes.extract_options!
      validations = defaults

      raise ArgumentError, "You need to supply at least one attribute" if attributes.empty?
      raise ArgumentError, "Attribute names must be symbols" if attributes.any?{ |attribute| !attribute.is_a?(Symbol) }
      raise ArgumentError, "You need to supply at least one validation" if validations.empty?
      
      validations.each do |val, options|
        attributes.each do |att|
          self.validations[val]||= {}
          self.validations[val][att] = options
        end
      end
    end
  end
  
  def self.included( base )
    Array.class_eval 'def extract_options!;last.is_a?(::Hash) ? pop : {}; end'
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods 
    base.validations = {}
  end
end
