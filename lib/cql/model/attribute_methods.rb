module Cql::Model::AttributeMethods
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods
  
  attr_reader :attributes
  
  def attributes=(hash)
    @attributes = {}
    hash.each { |k, v| @attributes[k.to_s] = v }
    @attributes
  end
  
  
end