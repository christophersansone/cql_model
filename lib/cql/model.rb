require 'active_model'

require 'active_support/concern'
require 'active_support/core_ext'

require 'cql/base'
require 'cql/statement'
require 'cql/model/version'

require 'cql/model/callbacks'
require 'cql/model/attribute_methods'
require 'cql/model/schema_methods'
require 'cql/model/finder_methods'
require 'cql/model/persistence_methods'
require 'cql/model/query_result'

module Cql
  class Model
    extend ActiveModel::Naming

    #include ActiveModel::Callbacks
    include ActiveModel::Conversion
    #include ActiveModel::Observing
    include ActiveModel::Serialization
    #include ActiveModel::Translation
    include ActiveModel::Validations

    include Cql::Model::AttributeMethods
    include Cql::Model::SchemaMethods
    include Cql::Model::FinderMethods
    include Cql::Model::PersistenceMethods
    include Cql::Model::Callbacks
    include Cql::Model::Dirty

    def initialize(attributes = {}, options = {})
      self.class.columns.each do |key, config|
        name = config[:attribute_name].to_sym

        module_eval <<-RUBY, __FILE__, __LINE__+1
          def #{name}
            read_attribute(#{name.inspect})
          end
        RUBY

        unless config[:read_only]
          module_eval <<-RUBY, __FILE__, __LINE__+1
            def #{name}=(value)
              write_attribute(#{name.inspect}, value)
            end
          RUBY
        end
                          
        class_eval do
          #attr_reader config[:attribute_name]
          #attr_writer config[:attribute_name] unless config[:read_only]
          define_attribute_method name
        end
      end

      @_attributes = {}
      @metadata = options[:metadata]
      @persisted = false
      @deleted = false

      attributes.each { |key, value| write_attribute(key, value) }

      self
    end

    def primary_key_attributes
      attributes.select { |k, v| primary_key.include?(k) }
    end
    
    def primary_value
      read_attribute(primary_key.first)
    end

    def quoted_primary_value
      Cql::Statement.quote(primary_value)
    end

    def persisted?
      @persisted
    end
    
    def generate_timeuuid
      Cql::TimeUuid::Generator.new.next
    end
    
    alias_method :generate_uuid, :generate_timeuuid

    def self.execute(query)
      cql_results = Cql::Base.connection.execute(query, consistency)
      Cql::Model::QueryResult.new(cql_results, self)
    end
    
    private
    
    def read_attribute(name)
      @_attributes[name.to_sym]
    end
    
    def write_attribute(name, val)
      if val.nil?
        @_attributes.delete(name.to_sym)
      else
        @_attributes[name.to_sym] = name
      end
    end

  end
end
