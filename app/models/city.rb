class City < ApplicationRecord
  has_many :transportations, foreign_key: :from_city_id
  has_many :destinations, through: :transportations, source: :to_city

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  # I REALLY NEED to refactor this.
  def route_to(city)
    destination_city = city.class == City ? city : City.find_by_name(city)
    p destination_city

    transportations = self.transportations
                          .where(to_city: destination_city)
                          .order(price: :asc)
                          .limit(1)

    if transportations.empty?
      # binding.pry
      common_destinations = self.destinations & destination_city.destinations
      
      return common_destinations.map do |common_destination|
        [
          self.transportations.where(to_city_id: common_destination.id).first,
          common_destination.transportations.where(to_city_id: destination_city.id).first
        ]
      end.sort_by do |transportations|
        transportations.reduce(0) { |acc, transportation| acc + transportation.price }
      end.first
    end

    transportations
  end
end
