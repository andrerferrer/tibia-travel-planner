class City < ApplicationRecord
  has_many :transportations, foreign_key: :from_city_id

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
