require 'rails_helper'

RSpec.describe PeopleController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('personGivenName - 1')
      expect(assigns(:people)[1].given_name).to eq('personGivenName - 10')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '3898' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @person' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
    end

    it 'redirects to people/:id' do
      expect(response).to redirect_to(person_path('xKrfpZSp'))
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person, @seat_incumbencies, @house_incumbencies, @current_party_membership,
    @most_recent_incumbency and @current_incumbency' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end

      assigns(:house_incumbencies).each do |house_incumbency|
        expect(house_incumbency).to be_a(Grom::Node)
        expect(house_incumbency.type).to eq('http://id.ukpds.org/schema/HouseIncumbency')
      end

      expect(assigns(:current_party_membership)).to be_a(Grom::Node)
      expect(assigns(:current_party_membership).type).to eq('http://id.ukpds.org/schema/PartyMembership')
      expect(assigns(:current_party_membership).current?).to be(true)

      expect(assigns(:most_recent_incumbency)).to be_a(Grom::Node)
      expect(assigns(:most_recent_incumbency).end_date).to be(nil)

      expect(assigns(:current_incumbency)).to be_a(Grom::Node)
      expect(assigns(:current_incumbency).current?).to be(true)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    context 'given a valid postcode' do
      before(:each) do
        get :show, params: { person_id: '7TX8ySd4' }, flash: { postcode: 'E2 0JA' }
      end

      it 'assigns @postcode, @postcode_constituency' do
        expect(assigns(:postcode)).to eq('E2 0JA')

        expect(assigns(:postcode_constituency)).to be_a(Grom::Node)
        expect(assigns(:postcode_constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    context 'given an invalid postcode' do
      before(:each) do
        get :show, params: { person_id: '7TX8ySd4' }, flash: { postcode: 'apple' }
      end

      it 'assigns @postcode and flash[:error]' do
        expect(assigns(:postcode)).to be(nil)
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end
    end
  end

  describe "POST postcode_lookup" do
    before(:each) do
      post :postcode_lookup, params: { person_id: '7TX8ySd4', postcode: 'E2 0JA' }
    end

    it 'assigns flash[:postcode]' do
      expect(flash[:postcode]).to eq('E2 0JA')
    end

    it 'redirects to people/:id' do
      expect(response).to redirect_to(person_path('7TX8ySd4'))
    end
  end



  describe "GET contact_points" do
    before(:each) do
      get :contact_points, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @contact_points' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:contact_points).each do |contact_point|
        expect(contact_point).to be_a(Grom::Node)
        expect(contact_point.type).to eq('http://id.ukpds.org/schema/ContactPoint')
      end
    end

    it 'renders the contact_points template' do
      expect(response).to render_template('contact_points')
    end
  end

  describe "GET parties" do
    before(:each) do
      get :parties, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @party_memberships' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:party_memberships).each do |party_membership|
        expect(party_membership).to be_a(Grom::Node)
        expect(party_membership.type).to eq('http://id.ukpds.org/schema/PartyMembership')
      end
    end

    it 'assigns @party_memberships in reverse chronological order' do
      expect(assigns(:party_memberships)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:party_memberships)[1].start_date).to eq(DateTime.new(1987, 6, 11))
    end

    it 'renders the parties template' do
      expect(response).to render_template('parties')
    end
  end

  describe "GET current_party" do
    before(:each) do
      get :current_party, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @party' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
    end

    it 'renders the current_party template' do
      expect(response).to render_template('current_party')
    end
  end

  describe "GET constituencies" do
    before(:each) do
      get :constituencies, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @seat_incumbencies' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end
    end

    it 'assigns @seat_incumbencies in reverse chronological order' do
      expect(assigns(:seat_incumbencies)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:seat_incumbencies)[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end

    it 'renders the parties template' do
      expect(response).to render_template('constituencies')
    end
  end

  describe "GET current_constituency" do
    before(:each) do
      get :current_constituency, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @constituency' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
    end

    it 'renders the current_constituency template' do
      expect(response).to render_template('current_constituency')
    end
  end

  describe "GET houses" do
    before(:each) do
      get :houses, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @incumbencies' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:incumbencies).each do |incumbency|
        expect(incumbency).to be_a(Grom::Node)
        expect(incumbency.type).to eq('http://id.ukpds.org/schema/Incumbency')
      end
    end

    it 'assigns @incumbencies in reverse chronological order' do
      expect(assigns(:incumbencies)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:incumbencies)[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end

    it 'renders the parties template' do
      expect(response).to render_template('houses')
    end
  end

  describe "GET current_house" do
    before(:each) do
      get :current_house, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @house' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
    end

    it 'renders the current_house template' do
      expect(response).to render_template('current_house')
    end
  end

  describe 'GET letters' do
    context 'there is a response' do
      before(:each) do
        get :letters, params: { letter: 't' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @people in alphabetical order' do
        expect(assigns(:people)[0].given_name).to eq('personGivenName - 1')
        expect(assigns(:people)[1].given_name).to eq('personGivenName - 10')
      end

      it 'renders the letters template' do
        expect(response).to render_template('letters')
      end
    end

    context 'there is no response' do
      before(:each) do
        get :letters, params: { letter: 'x' }
      end

      it 'http status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'has a blank @people array' do
        expect(controller.instance_variable_get(:@people)).to be_empty
      end
    end
  end

  describe "GET a_to_z" do
    before(:each) do
      get :a_to_z
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z template' do
      expect(response).to render_template('a_to_z')
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'cam' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'renders the lookup_by_letters template' do
        expect(response).to render_template('lookup_by_letters')
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'creasy' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to people/:id' do
        expect(response).to redirect_to(person_path('SmopkDY2'))
      end
    end
  end

  # Test for ApplicationController Parliament::ClientError handling
  describe 'rescue_from Parliament::ClientError' do
    it 'raises an ActionController::RoutingError' do
      expect{ get :show, params: { person_id: '12345678' } }.to raise_error(ActionController::RoutingError)
    end
  end
end
