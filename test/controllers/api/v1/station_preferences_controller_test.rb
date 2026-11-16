
require "test_helper"

class Api::V1::StationPreferencesControllerTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = []

  setup do
    @user = User.create!(
      email: "passenger@example.com",
      password: "Password123!"
    )

    @station = Station.create!(
      external_id: "TEST_001",
      name: "Warszawa Centralna"
    )

    @token = Sessions::Issue.new(user: @user).call[:token]
  end

  test "records a station selection for authenticated user" do
    assert_difference "StationPreference.count", 1 do
      post "/api/v1/station_preferences",
           params: { station_id: @station.id },
           headers: {
             "Authorization" => "Bearer #{@token}"
           },
           as: :json
    end

    assert_response :success

    preference = StationPreference.find_by!(
      user: @user,
      station: @station
    )

    assert_equal 1, preference.selection_count
  end

  test "repeated selections increment the existing preference" do
    assert_difference "StationPreference.count", 1 do
      2.times do
        post "/api/v1/station_preferences",
             params: { station_id: @station.id },
             headers: {
               "Authorization" => "Bearer #{@token}"
             },
             as: :json

        assert_response :success
      end
    end

    preference = StationPreference.find_by!(
      user: @user,
      station: @station
    )

    assert_equal 2, preference.selection_count
  end

  test "rejects requests without authentication" do
    assert_no_difference "StationPreference.count" do
      post "/api/v1/station_preferences",
           params: { station_id: @station.id },
           as: :json
    end

    assert_response :unauthorized
  end

  test "ignores user_id supplied by the client" do
    bob = User.create!(
      email: "bob@example.com",
      password: "Password123!"
    )

    post "/api/v1/station_preferences",
         params: {
           user_id: bob.id,
           station_id: @station.id
         },
         headers: {
           "Authorization" => "Bearer #{@token}"
         },
         as: :json

    assert_response :success

    assert_equal 1, @user.station_preferences.count
    assert_equal 0, bob.station_preferences.count
  end
end
