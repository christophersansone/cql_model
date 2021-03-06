require 'spec_helper'

describe 'Cql::Model Finders' do
  before :all do
    Cql::Base.establish_connection(host: '127.0.0.1')
    Cql::Base.connection.use('cql_model_test')
  end

  before :each do
    @person = Person.new(id: 123, first_name: 'Alex', last_name: 'Jones')
  end

  after :each do
    Cql::Base.connection.execute('DELETE FROM people WHERE id = 123')
  end

  describe '#save' do
    it { @person.save.must_be_instance_of Person }
    it do
      @person.persisted?.must_equal false
      @person.save
      @person.persisted?.must_equal true
    end
  end

  describe '#delete' do
    before :each do
      @person.save
    end

    it { @person.delete.must_be_instance_of Person }

    it do
      @person.deleted?.must_equal false
      @person.persisted?.must_equal true
      @person.delete
      @person.deleted?.must_equal true
      @person.persisted?.must_equal false
    end

    it do
      @person.delete
      Person.find(123).must_be_nil
    end
  end
end
