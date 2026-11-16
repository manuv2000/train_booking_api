require "csv"

module Stations
  class ImportGtfs
    BATCH_SIZE = 500

    REQUIRED_HEADERS = %w[
      stop_id
      stop_name
      location_type
      stop_lat
      stop_lon
    ].freeze

    def initialize(file_path)
      @file_path = file_path
    end

    def call
      headers = CSV.open(@file_path, &:first)

      duplicates = headers.tally.select do |_name, count|
        count > 1
      end.keys

      unless duplicates.empty?
        raise ArgumentError,
              "Duplicate CSV headers: #{duplicates.join(', ')}"
      end

      missing_headers = REQUIRED_HEADERS - Array(headers)

      unless missing_headers.empty?
        raise ArgumentError,
              "Missing CSV headers: #{missing_headers.join(', ')}"
      end

      batch = []
      imported = 0

      CSV.foreach(@file_path, headers: true) do |row|
        next unless row["location_type"] == "1"

        attributes = {
          external_id: row["stop_id"],
          name: row["stop_name"],
          latitude: row["stop_lat"],
          longitude: row["stop_lon"]
        }

        next if attributes[:external_id].to_s.strip.empty?
        next if attributes[:name].to_s.strip.empty?

        batch << attributes

        if batch.size >= BATCH_SIZE
          Station.upsert_all(batch, unique_by: :external_id)
          imported += batch.size
          batch.clear
        end
      end

      unless batch.empty?
        Station.upsert_all(batch, unique_by: :external_id)
        imported += batch.size
      end

      imported
    end
  end
end
