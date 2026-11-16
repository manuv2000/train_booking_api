
module StationPreferences
  class RecordSelection
    def initialize(user:, station:)
      @user = user
      @station = station
    end

    def call
      preference = @user.station_preferences.create_or_find_by!(
        station: @station
      )

      preference.increment!(:selection_count)

      preference
    end
  end
end
