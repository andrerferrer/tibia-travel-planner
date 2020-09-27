require 'rgl/adjacency'
require 'rgl/dijkstra'

graph = RGL::DirectedAdjacencyGraph.new

city_ids = City.pluck :id

graph.add_vertices *city_ids

transportations = Transportation.all.to_a
edge_weights = transportations.reduce({}) do |acc, transportation|
	acc[ [transportation.from_city.id, transportation.to_city.id] ] = transportation.price
	acc
end

edge_weights.each { |(city1, city2), _weight| graph.add_edge(city1, city2) }

shortest_path = graph.dijkstra_shortest_path(edge_weights, 1, 11)

transportations = shortest_path.map.with_index do |city_id, index|
	Transportation.find_by(
		from_city_id: city_id, 
		to_city_id: shortest_path[index + 1]
	) if shortest_path[index + 1]
end

transportations