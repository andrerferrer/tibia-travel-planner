class City < ApplicationRecord
  has_many :transportations, foreign_key: :from_city_id
  has_many :destinations, through: :transportations, source: :to_city

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  def route_to(city)
    require 'rgl/adjacency'
    require 'rgl/dijkstra'

    graph = RGL::DirectedAdjacencyGraph.new

    city_ids = City.pluck :id

    graph.add_vertices *city_ids
    transportations_details = Transportation.pluck :from_city_id, :to_city_id, :price
    edge_weights = transportations_details.reduce({}) do |acc, transportation_details|
      acc[ [transportation_details[0], transportation_details[1]] ] = transportation_details[2]
      acc
    end

    edge_weights.each { |(city1, city2), _weight| graph.add_edge(city1, city2) }

    shortest_path = graph.dijkstra_shortest_path(edge_weights, self.id, city.id)

    final_transportations = shortest_path.map.with_index do |city_id, index|
        Transportation.find_by(
          from_city_id: city_id,
          to_city_id: shortest_path[index + 1]
        ) if shortest_path[index + 1]
    end

    final_transportations.compact
  end
end

# Old and Trashy code
# def route_to(city)
#   destination_city = city.class == City ? city : City.find_by_name(city)
#   p destination_city

#   transportations = self.transportations
#                         .where(to_city: destination_city)
#                         .order(price: :asc)
#                         .limit(1)

#   if transportations.empty?
#     # binding.pry
#     common_destinations = self.destinations & destination_city.destinations
    
#     return common_destinations.map do |common_destination|
#       [
#         self.transportations.where(to_city_id: common_destination.id).first,
#         common_destination.transportations.where(to_city_id: destination_city.id).first
#       ]
#     end.sort_by do |transportations|
#       transportations.reduce(0) { |acc, transportation| acc + transportation.price }
#     end.first
#   end

#   transportations
# end