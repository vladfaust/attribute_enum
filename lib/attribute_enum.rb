require 'attribute_enum/version'
require 'active_support/inflector'

module AttributeEnum
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_eval do
      @enums = {}
    end
  end

  module ClassMethods
    attr_reader :enums

    # Turns a dot-accessible class attribute to an enum (a.k.a bytefield).
    # Class must have read'n'write attribute named [what's being enumerated].
    #
    # @example
    #
    #   class Payment
    #     include AttributeEnum
    #     attr_accessor :status
    #
    #     def initialize(status = 0)
    #       @status = status
    #     end
    #
    #     enum :status, [ :active, :inactive ]
    #   end
    #
    #   payment = Payment.new
    #
    #   payment.get_status # => :active
    #   payment.inactive? # => false
    #   payment.set_status(:inactive) # => true
    #   payment.set_status(:invalid) # => ArgumentError('unknown value invalid')
    #   payment.active? # => false
    #   payment.active! # => true
    #   payment.statuses # => [:active, :inactive]
    #   payment.get_statuses # => [:active, :inactive]
    #
    #   Payment.statuses # => [:active, :inactive]
    #   Payment.get_statuses # => [:active, :inactive]
    #   Payment.get_status(1) # => :inactive
    #   Payment.get_status(:active) # => 0
    #   Payment.get_status('invalid') # => ArgumentError('valid argument is either Integer or Symbol')
    #
    def enum(enumerated, values)
      if values.is_a? Hash
        values.each do |key,val|
          raise ArgumentError, "index should be numeric, #{key} provided wich it's a #{key.class}" unless key.is_a? Integer
          raise ArgumentError "value should be a symbol, #{val} provided wich it's a #{val.class}" unless val.is_a? Symbol
        end
      elsif values.is_a? Array
        values = Hash[values.map.with_index { |v, i| [i,v] }]
      else
        raise ArgumentError, "#enum expects the second argument to be an array of symbols or a hash like { index => :value }"
      end

      # Symbolize values
      #
      values.each do |key, val|
        s_key = key.to_s
        values[key]   = values[key].to_sym   if values[key]
        values[s_key] = values[s_key].to_sym if values[s_key]
      end

      pluralized = enumerated.to_s.pluralize

      # ###
      # Instance methods
      # ###

      # obj.set_status :active
      #
      define_method "set_#{enumerated}" do |value|
        index = self.class.enums[enumerated].rassoc(value)
        raise ArgumentError.new("unknown value #{ value }") unless (index && (index = index.first))
        self.send("#{enumerated}=", index)
        true
      end

      # obj.get_status # => :active
      #
      define_method "get_#{enumerated}" do
        self.class.enums[enumerated].fetch(self.send(enumerated), nil)
      end

      values.each do |key, value|
        # obj.inactive? # => false
        #
        define_method "#{value}?" do
          self.send("get_#{enumerated}") == value
        end

        # obj.inactive! # => true
        #
        define_method "#{value}!" do
          self.send("set_#{enumerated}", value)
        end
      end

      # obj.statuses # => [:active, :inactive]
      #
      define_method pluralized do
        self.class.enums[enumerated].map{ |k, v| v }
      end

      # obj.get_statuses # => [:active, :inactive]
      #
      alias_method "get_#{pluralized}", pluralized

      # ###
      # Class methods
      # ###

      # Obj.statuses # => [:active, :inactive]
      #
      define_singleton_method pluralized do
        self.enums[enumerated].map{ |k, v| v }
      end

      # Obj.get_statuses # => [:active, :inactive]
      #
      singleton_class.class_eval do
        alias_method "get_#{pluralized}", pluralized
      end

      # Obj.get_status(0) # => :active
      # Obj.get_status(:active) # => 0
      #
      define_singleton_method "get_#{enumerated}" do |arg|
        if arg.is_a? Integer
          self.enums[enumerated].fetch(arg, nil)
        elsif arg.is_a? Symbol
          key = self.enums[enumerated].rassoc(arg)
          key ? key[0] : nil
        else
          raise ArgumentError.new('valid argument is either Integer or Symbol')
        end
      end

      # Fin
      enums[enumerated] = values
    end
  end
end

