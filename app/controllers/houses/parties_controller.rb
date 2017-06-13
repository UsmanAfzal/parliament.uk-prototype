class Houses::PartiesController < ApplicationController

  def parties
    house_id = params[:house_id]

    @house, @parties = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
    )

    @house = @house.first
    @parties = @parties.sort_by(:name)
  end

  def current_parties
    house_id = params[:house_id]

    @house, @parties = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties.current,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
    )

    @house = @house.first
    @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
  end

  def party
    house_id = params[:house_id]
    party_id = params[:party_id]

    @house, @party = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
    )

    @house = @house.first
    @party = @party.first
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)

    raise ActionController::RoutingError, 'Invalid party id' if @party.nil?
  end

  def party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )
    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members(letter),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )
    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def current_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members.current,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def current_party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members.current(letter),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def a_to_z_party_members
    @house_id = params[:house_id]
    @party_id = params[:party_id]

    @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).parties(@party_id).members.a_z_letters)
  end

  def a_to_z_current_party_members
    @house_id = params[:house_id]
    @party_id = params[:party_id]

    @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).parties(@party_id).members.current.a_z_letters)
  end

end