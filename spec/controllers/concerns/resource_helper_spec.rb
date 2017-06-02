require 'rails_helper'

RSpec.describe ResourceHelper do

  it 'is a module' do
    expect(ResourceHelper).to be_a(Module)
  end

  it 'has a list of acceptable object types' do
    expect(ResourceHelper::ACCEPTABLE_OBJECT_TYPES).not_to be nil
  end

  context 'acceptable object types' do
    it 'includes Person' do
      expect(ResourceHelper::ACCEPTABLE_OBJECT_TYPES[:Person]).to eq('people_path')
    end
  end

  context 'checking for acceptable object type' do

    before(:each) do
      @node_type = 'http://id.ukpds.org/schema/Person'
    end

    it 'should extract object type from url' do
      expect(ResourceHelper.get_object_type(@node_type)).to eq(:Person)
    end

    it 'should return route if node type is an acceptable object type' do
      @node_type = ResourceHelper.get_object_type(@node_type)
      expect(ResourceHelper.check_acceptable_object_type(@node_type)).to eq('people_path')
    end

    it 'should return nil if node type is not an acceptable object type' do
      @node_type = :Test
      expect(ResourceHelper.check_acceptable_object_type(@node_type)).to eq(nil)
    end
  end





end
