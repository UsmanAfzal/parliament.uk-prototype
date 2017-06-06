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
    context 'successfully' do
      before(:each) do
        get :show, params: { resource_id: 'xP2kB45W' }
      end

      it 'assigns @results if grom nodes can be found' do
        assigns(:results).each do |result|
          expect(result).to be_a(Grom::Node)
        end
      end

      it 'redirects to people path' do
        expect(response).to be_redirect
      end
    end

    context 'unsuccessfully' do

      it 'raises error if no grom nodes can be found (404)' do
        expect{get :show, params: { resource_id: '12345678' }}.to raise_error(ActionController::RoutingError)
      end
    end
  end


end
