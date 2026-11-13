
require "csv"

module Stations
  class ImportGtfs
    BATCH_SIZE = 500

    def initialize(file_path)
      @file_path = file_path
    end

    def call
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
