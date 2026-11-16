class Api::V1::StationsController < ApplicationController
  def index
    stations = Stations::Search.new(
      query: params[:name],
      external_id: params[:external_id],
      limit: 20
    ).call

    render json: {
      stations: stations.as_json(
        only: [ :id, :external_id, :name, :latitude, :longitude ]
      )
    }
  end
end
