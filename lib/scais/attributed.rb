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
        @attributes[key] = name
      end
    end
  end
end
