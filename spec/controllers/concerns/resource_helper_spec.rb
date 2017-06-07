require 'rails_helper'

RSpec.describe ResourceHelper, vcr: true do

  it 'is a module' do
    expect(ResourceHelper).to be_a(Module)
  end

  it 'has a list of acceptable object types' do
    expect(ResourceHelper::ACCEPTABLE_OBJECT_TYPES).not_to be nil
  end

  context 'acceptable object types' do
    it 'includes Person' do
      expect(ResourceHelper::ACCEPTABLE_OBJECT_TYPES[:PimsPerson]).to eq('people')
    end
  end

  context 'checking for acceptable object type' do

    before(:each) do
      @node_type = 'http://id.ukpds.org/schema/PimsPerson'
    end

    it 'should extract object type from url' do
      expect(ResourceHelper.get_object_type(@node_type)).to eq(:PimsPerson)
    end

    it 'should return route if node type is an acceptable object type' do
      @node_type = ResourceHelper.get_object_type(@node_type)
      expect(ResourceHelper.check_acceptable_object_type(@node_type)).to eq('people')
    end

    it 'should return nil if node type is not an acceptable object type' do
      @node_type = :Test
      expect(ResourceHelper.check_acceptable_object_type(@node_type)).to eq(nil)
    end
  end

  context 'producing statements for view' do

    before(:each) do
      resource_uri = "http://id.ukpds.org/sYpq0s7D"
      @results = ParliamentHelper.parliament_request.resources.get(params: { uri: resource_uri })
    end

    it 'produces an array of single statements' do
      expect(ResourceHelper.produce_statements(@results)).to be_a(Array)
      expect(ResourceHelper.produce_statements(@results)[0]).to be_a(Array)
      expect(ResourceHelper.produce_statements(@results).count).to eq(15)
    end

  end





end
