require 'rails_helper'

RSpec.describe ResourceController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET grom nodes' do

    before(:each) do
      get :show, params: { resource_id: '7TX8ySd4' }
    end

    it 'assigns @nodes' do
      assigns(:nodes).each do |node|
        expect(node).to be_a(Grom::Node)
      end
    end

  end


end
