require "test_helper"

class Api::V1::StationsControllerTest < ActionDispatch::IntegrationTest
  self.fixture_table_names = []

  setup do
    @station = Station.create!(
      external_id: "TEST_WAW_001",
      name: "Warszawa Centralna"
    )
  end

  test "returns stations matching the search query" do
    get "/api/v1/stations",
      params: { name: "Warszawa" }

    puts "HTTP status: #{response.status}"
    puts "Response body: #{response.body}"

    assert_response :success

    body = JSON.parse(response.body)

    assert body["stations"].is_a?(Array)

    station_data = body["stations"].find do |station|
      station["id"] == @station.id
    end

    assert_not_nil station_data

    assert_equal @station.name, station_data["name"]
    assert_equal @station.external_id, station_data["external_id"]
  end

  test "returns an empty array when no stations match" do
    get "/api/v1/stations",
      params: { name: "NonexistentStationXYZ" }

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal [], body["stations"]
  end
end
