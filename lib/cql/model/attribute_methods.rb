module Cql::Model::AttributeMethods
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods
  
  attr_reader :attributes
  
  def attributes=(hash)
    column_keys = self.class.columns.keys
    @attributes = hash.select { |key, value| column_keys.include?(key.to_sym) }  
  end
  
  
end