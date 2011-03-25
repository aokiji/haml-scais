module Validations
  class ManyValidator
    def validate(record, att, options = {})
      val = record.send(att)
      if options[:exactly] && val.size != options[:exactly].to_i
        record.errors<< "#{att} size is not exactly #{options[:exactly].to_i}"
      elsif options[:minimum] && val.size < options[:minimum].to_i
        record.errors<< "#{att} size is #{val.size} but minimum is #{options[:minimum]}"
      elsif options[:maximum] && val.size > options[:maximum].to_i
        record.errors<< "#{att} size is #{val.size} but maximum is #{options[:maximum]}"
      end
    end
  end
end
