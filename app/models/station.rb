class Station < ApplicationRecord
  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
end
