class ResourceController < ApplicationController

  def index
  end

  def show
    resource_id = params[:resource_id]
    resource_url = "resources?uri=http://id.ukpds.org/#{resource_id}"

    @nodes = RequestHelper.filter_response_data(
      parliament_request.resource_url
      'http://id.ukpds.org/schema/Resource'
    )

    # If 404, raise error

    # If 200, do the below

    # find the first node_type
    # @nodes.first.type

    # use ResourceHelper.check_acceptable_object_type to get route people_path
      # if there is a route, redirect
        # Rails.application.routes.url_helpers.send("people_path")

      # else output table of data

  end


end
