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
require 'cql/model/dirty'

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
      @attributes = attributes
      @metadata = options[:metadata]
      @persisted = false
      @deleted = false

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
      @attributes[name.to_sym]
    end
    
    def write_attribute(name, val)
      @attributes[name.to_sym] = name
    end

  end
end
