module Cql::Model::Callbacks
  extend ActiveSupport::Concern

  HOOKS = [:save, :create, :update, :destroy, :validation]
  CALLBACKS = HOOKS.map { |hook| [:"before_#{hook}", :"after_#{hook}"] }.flatten

  included do
    extend ActiveModel::Callbacks
    define_model_callbacks *HOOKS
  end

  def save(*args)
    run_callbacks(:save) do
      run_callbacks(persisted? ? :update : :create) do
        super
        self
      end
    end
  end

  def destroy(*args)
    run_callbacks(:destroy) do
      super
      self
    end
  end

end
