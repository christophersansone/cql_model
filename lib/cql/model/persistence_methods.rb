module Cql::Model::PersistenceMethods
  extend ::ActiveSupport::Concern

  def save
    atts = attributes
    fields = atts.keys.join(', ')
    placeholders = Cql::Statement.placeholders(atts.length).join(', ')
    values = atts.values

    query = Cql::Statement.sanitize("INSERT INTO #{table_name} (#{fields}) VALUES (#{placeholders})", values)
    Cql::Base.connection.execute(query)

    @persisted = true
    self
  end

  def deleted?
    @deleted
  end

  def delete
    clauses = Cql::Statement.clauses(primary_key_attributes).join(' AND ')
    query = Cql::Statement.sanitize("DELETE FROM #{table_name} WHERE #{clauses}")
    Cql::Base.connection.execute(query)

    @deleted = true
    @persisted = false
    self
  end

  module ClassMethods

  end
end
