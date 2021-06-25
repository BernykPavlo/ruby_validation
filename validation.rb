module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attribute, **rules)
      instance_variable_set('@arguments', {}) unless instance_variable_defined?('@arguments')
      instance_variable_get('@arguments')[attribute] = rules
    end
  end

  module InstanceMethods

    def validate!
      self.class.instance_variable_get('@arguments').each do |attribute, rules|
        rules.each do |key, value|
          send("validate_#{key}", attribute, value)
        end
      end
      true
    end

    def valid?
      validate!
    rescue ArgumentError => e
      puts e.message
      false
    end

    private

    def validate_presence(attribute, value)
      item = instance_variable_get("@#{attribute}")
      raise ArgumentError, "Argument #{attribute} presence is not #{value}..." unless (!item.nil? && item != '') == value
    end

    def validate_format(attribute, format)
      item = instance_variable_get("@#{attribute}")
      raise ArgumentError, "Argument #{attribute} does not match format..." unless item =~ format
    end

    def validate_type(attribute, type)
      class_name = instance_variable_get("@#{attribute}").to_s
      raise ArgumentError, "Argument #{attribute} does not belongs to #{type} class..." if class_name != type
    end
  end
end
