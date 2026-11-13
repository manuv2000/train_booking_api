require "csv"

total = 0
secondary_ids = 0
platform_flags = Hash.new(0)

location_types = Hash.new(0)

CSV.foreach("data/imports/stops.csv", headers: true) do |row|
    total += 1

    secondary_ids += 1 unless row["plk_secondary_id"].to_s.empty?

    value = row["only_platforms"]
    
    platform_flags[value] += 1
    location_types[row["location_type"]] += 1

    if row["only_platforms"].to_s.include?("/")
        puts({
            stop_id: row["stop_id"],
            name: row["stop_name"],
            location_type: row["location_type"],
            only_platforms: row["only_platforms"],
            parent_station: row["parent_station"]
        })
    end
end

puts "Total records: #{total}"
puts "Records with PLK secondary ID: #{secondary_ids}"
puts "only_platforms values: #{platform_flags}"
puts "Location types: #{location_types}"