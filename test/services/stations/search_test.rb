
require "test_helper"

class Stations::SearchTest < ActiveSupport::TestCase
  setup do
    Station.create!(
      external_id: "T1",
      name: "Nowa Warszawa"
    )

    Station.create!(
      external_id: "T2",
      name: "Warszawa Centralna"
    )

    Station.create!(
      external_id: "T3",
      name: "Kraków Główny"
    )

    Station.create!(
      external_id: "T4",
      name: "Warszawa Zachodnia"
    )
  end

  test "prioritizes prefix matches" do
    results = Stations::Search.new(
      query: "Warszawa"
    ).call

    assert_equal [
      "Warszawa Centralna",
      "Warszawa Zachodnia",
      "Nowa Warszawa"
    ], results.pluck(:name)
  end

  test "returns no stations for blank query" do
    results = Stations::Search.new(
      query: ""
    ).call

    assert_empty results
  end
  test "setup creates four stations" do
    assert_equal 4, Station.count
  end
end
