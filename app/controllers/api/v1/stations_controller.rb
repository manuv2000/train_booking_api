
class Api::V1::StationsController < ApplicationController
  def index
    stations = Station.all

    if params[:external_id].present?
      stations = stations.where(external_id: params[:external_id])
    end

    if params[:name].present?
      stations = stations.where(
        "name ILIKE ?",
        "%#{params[:name]}%"
      )
    end

    stations = stations.order(:name).limit(20)

    render json: {
      stations: stations.as_json(
        only: [ :id, :external_id, :name, :latitude, :longitude ]
      )
    }
  end
end
