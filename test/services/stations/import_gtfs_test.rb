
require "test_helper"
require "tempfile"

class Stations::ImportGtfsTest < ActiveSupport::TestCase
  setup do
    @file_path = Rails.root.join(
      "test/fixtures/files/stations_sample.csv"
    )
  end

  test "imports only valid stations" do
    importer = Stations::ImportGtfs.new(@file_path)

    assert_difference("Station.count", 2) do
      importer.call
    end

    assert Station.exists?(external_id: "100")
    assert Station.exists?(external_id: "101")

    assert_not Station.exists?(external_id: "102")
    assert_not Station.exists?(external_id: "103")
  end

  test "importing twice does not duplicate stations" do
    importer = Stations::ImportGtfs.new(@file_path)

    importer.call

    assert_no_difference("Station.count") do
      importer.call
    end

    assert_equal 2, Station.count
  end

  test "rejects a CSV with invalid headers" do
    file_path = Rails.root.join(
      "test/fixtures/files/stations_missing_headers.csv"
    )

    assert_no_difference("Station.count") do
      assert_raises(ArgumentError) do
        Stations::ImportGtfs.new(file_path).call
      end
    end
  end

  test "rejects CSV with missing required headers" do
    Tempfile.create([ "invalid_stations", ".csv" ]) do |tempfile|
      tempfile.write(
        "stop_id,stop_name,stop_lat,stop_lon\n" \
        "100,Warszawa Centralna,52.2297,21.0122\n"
      )

      tempfile.flush

      assert_no_difference("Station.count") do
        error = assert_raises(ArgumentError) do
          Stations::ImportGtfs.new(tempfile.path).call
        end

        assert_includes error.message, "location_type"
      end
    end
  end
end
