
module Stations
  class Search
    DEFAULT_LIMIT = 10
    MAX_LIMIT = 100

    def initialize(query: nil, external_id: nil, limit: DEFAULT_LIMIT)
      @query = query.to_s.strip
      @external_id = external_id.to_s.strip
      @limit = limit.to_i.clamp(1, MAX_LIMIT)
    end

    def call
      return Station.none if @query.empty? && @external_id.empty?

      stations = Station.all

      if @external_id.present?
        stations = stations.where(external_id: @external_id)
      end

      if @query.present?
        escaped_query = Station.sanitize_sql_like(@query)

        contains_pattern = "%#{escaped_query}%"
        prefix_pattern = "#{escaped_query}%"

        stations = stations.where("name ILIKE ?", contains_pattern)

        priority_sql = Station.sanitize_sql_array([
          "CASE WHEN name ILIKE ? THEN 0 ELSE 1 END",
          prefix_pattern
        ])

        stations = stations
          .order(Arel.sql(priority_sql))
          .order(:name)
      end

      stations.limit(@limit)
    end
  end
end
