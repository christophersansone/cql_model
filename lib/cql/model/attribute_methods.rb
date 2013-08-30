module Cql::Model::AttributeMethods
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods
  
  attr_reader :attributes
  
  def attributes=(hash)
    @attributes = {}
    hash.each { |k, v| @attributes[k.to_s] = v }
    @attributes
  end
  
  private
  
  def read_attribute(name)
    @attributes[name.to_s]
  end
  
  def write_attribute(name, val)
    @attributes[name.to_s] = val
  end
  
end