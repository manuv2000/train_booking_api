class StationPreference < ApplicationRecord
  belongs_to :user
  belongs_to :station

  validates :selection_count,
            numericality: { greater_than_or_equal_to: 0 }
end
