module Cql::Model::Dirty
  extend ActiveSupport::Concern
  include ActiveModel::Dirty
  
  def save
    super
    @previously_changed = changes
    @changed_attributes.clear
    self
  end
  
  private
  
  def write_attribute(name, val)
    attribute_will_change!(name.to_s) unless value == read_attribute(name)
    super
  end
end