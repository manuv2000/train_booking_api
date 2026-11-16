class Api::V1::StationPreferencesController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]

  def create
    station = Station.find(params[:station_id])

    preference = StationPreferences::RecordSelection.new(
      user: current_user,
      station: station
    ).call

    render json: {
      id: preference.id,
      station_id: preference.station_id,
      selection_count: preference.selection_count
    }, status: :ok
  end
end
