class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  has_many :station_preferences, dependent: :destroy
  has_many :sessions, dependent: :destroy
end
