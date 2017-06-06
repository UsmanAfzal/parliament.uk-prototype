class ResourceController < ApplicationController

  def index
  end

  def show
    resource_id = params[:resource_id]
    resource_url = "resources?uri=http://id.ukpds.org/#{resource_id}"

    begin
      @results = parliament_request.resources.get(params: { uri: "http://id.ukpds.org/#{resource_id}" })

    # If 404, raise error
    rescue Parliament::NoContentResponseError => error
      raise ActionController::RoutingError, error.message
    end

    # Find the first node_type
    type = @results.first.type.split('/').last.to_sym

    # use ResourceHelper.check_acceptable_object_type to get route people_path
    path = ResourceHelper.check_acceptable_object_type(type)

    # if there is a route, redirect
    unless path.nil?
      redirect_to "/#{path}/#{resource_id}"
    end


    # else output table of data



  end


end
