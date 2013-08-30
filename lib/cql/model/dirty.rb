module Cql::Model::Dirty
  include ActiveModel::Dirty
  extend ActiveSupport::Concern
  
  def save
    super
    @previously_changed = changes
    @changed_attributes.clear
    self
  end
  
  private
  
  def write_attribute(name, val)
    attribute_will_change!(name) unless value == read_attribute(name)
    super
  end
end