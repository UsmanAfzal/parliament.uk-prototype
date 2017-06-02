class ResourceController < ApplicationController

  def index
  end

  def show
    resource_id = params[:resource_id]
    @nodes = RequestHelper.filter_response_data(
      parliament_request.resource(resource_id),
      'http://id.ukpds.org/schema/Resource'
    )

    # logic to find the first node_type

  end


end
