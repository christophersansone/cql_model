module Cql::Model::SchemaMethods
  extend ::ActiveSupport::Concern

  def table_name
    self.class.table_name
  end

  def primary_key
    self.class.primary_key
  end

  module ClassMethods
    def table_name
      @table_name ||= self.model_name.plural
    end

    def columns
      @columns ||= {}
    end

    def consistency(consistency_value = nil)
      @consistency ||= consistency_value.nil? ? :quorum : consistency_value.to_sym
    end

    def primary_key(*key_names)
      @primary_key ||= key_names.any? ? key_names : [:id]
      @primary_key.each { |f| column(f) unless columns.has_key?(f.to_sym) }
      @primary_key
    end

    def column(attribute_name, options = {})
      column_name = options[:column_name] || attribute_name

      @columns ||= {}
      @columns[column_name.to_s] = {
        attribute_name: attribute_name.to_sym,
      }.merge(options)
      
      module_eval <<-RUBY, __FILE__, __LINE__+1
        def #{column_name}
          read_attribute(#{column_name.inspect})
        end
      RUBY

      unless options[:read_only]
        module_eval <<-RUBY, __FILE__, __LINE__+1
          def #{column_name}=(value)
            write_attribute(#{column_name.inspect}, value)
          end
        RUBY
      end

      define_attribute_method name
      
    end
  end
end
