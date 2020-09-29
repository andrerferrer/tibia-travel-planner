class Transportation < ApplicationRecord
  belongs_to :from_city, class_name: 'City'
  belongs_to :to_city, class_name: 'City'

  validates :means, presence: true, inclusion: { in: ['boat', 'magic carpet', 'steamship', 'quest'] }
end
