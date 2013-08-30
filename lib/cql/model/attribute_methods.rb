module Cql::Model::AttributeMethods
  include ActiveModel::AttributeMethods
  
  def attributes
    result = {}
    self.class.columns.each do |key, config|
      result[key] = instance_variable_get("@#{config[:attribute_name].to_s}".to_sym)
    end
    result
  end
  
  
end