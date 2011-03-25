module Validations
  class PresenceValidator
    def validate(record, att, options = {})
      val = record.send(att)
      record.errors<< "Missing #{att}" if val.nil? || (val.respond_to?('empty?') && val.empty?)
    end
  end
end
