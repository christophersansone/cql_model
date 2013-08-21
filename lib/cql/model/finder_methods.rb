module Cql::Model::FinderMethods
  extend ::ActiveSupport::Concern

  module ClassMethods
    def all
      query = "SELECT * FROM #{table_name}"
      execute(query)
    end

    def find(*args)
      raise StandardError, '#find cannot be called on models with composite primary keys' if primary_key.length > 1
      values = args.to_a.flatten
      placeholders = Cql::Statement.placeholders(values.count).join(', ')
      query = Cql::Statement.sanitize("SELECT * FROM #{table_name} WHERE #{primary_key.first} IN (#{placeholders})", values)

      if args[0].is_a?(Array) || args.size > 1
        execute(query).to_a
      else
        execute(query).first
      end
    end

    def find_by(hash)
      where(hash)
    end
    
    def where(hash_or_string, values = [])
      clauses = 
        if hash_or_string.kind_of?(Hash)
          Cql::Statement.clauses(hash_or_string).join(' AND ')
        elsif hash_or_string.kind_of?(String)
          Cql::Statement.sanitize(hash_or_string, values)
        else
          raise ArgumentError, 'Expected a hash or string'
        end
            
      query = "SELECT * FROM #{table_name} WHERE #{clauses} ALLOW FILTERING"
      execute(query).to_a
    end
  end
end
