class ResourceController < ApplicationController

  def index
    @results = session[:results]
    session[:results] = nil
  end

  def show
    resource_id = params[:resource_id]
    resource_uri = "http://id.ukpds.org/#{resource_id}"

    begin
      @results = parliament_request.resources.get(params: { uri: resource_uri })

    rescue Parliament::NoContentResponseError => error
      raise ActionController::RoutingError, error.message
    end

    # Find the first node_type (currently only testing for something which has a type)
    type = @results.first.type.split('/').last.to_sym

    # Get route path
    path = ResourceHelper.check_acceptable_object_type(type)

    # if there is a route, redirect, else output table of data
    # path.nil? ? render : redirect_to "/#{path}/#{resource_id}"
    unless path.nil?
      redirect_to "/#{path}/#{resource_id}"
    else
      @statements = ResourceHelper.produce_statements(@results)
      p @statements.first
      # @statements = []
      # @results.each do |result|
      #   result.statements.each do |statement|
      #     @statements << statement.to_a
      #   end
      # end
      render
    end

  end



end
