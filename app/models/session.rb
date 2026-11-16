class Session < ApplicationRecord
  belongs_to :user

  scope :expired, -> {
    where("expires_at <= ?", Time.current)
  }
end
