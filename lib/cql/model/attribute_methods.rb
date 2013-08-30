module Cql::Model::AttributeMethods
  extend ActiveSupport::Concern
  include ActiveModel::AttributeMethods
  
  def attributes
    result = {}
    self.class.columns.each do |key, config|
      result[key] = read_attribute(config[:attribute_name])
    end
    result
  end
  
  
end