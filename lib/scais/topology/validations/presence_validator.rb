module Validations
  class PresenceValidator
    def validate(record, att, options = {})
      val = record.instance_variable_get("@#{att}")
      record.errors<< "Missing #{att}" if val.nil? || (val.respond_to?('empty?') && val.empty?)
    end
  end
end
