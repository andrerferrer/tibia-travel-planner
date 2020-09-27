# I took this solution from this tutorial
# https://www.rubyguides.com/2017/05/graph-theory-in-ruby/

require 'rgl/adjacency'
require 'rgl/dijkstra'

graph = RGL::DirectedAdjacencyGraph.new

graph.add_vertices "Los Angeles", "New York", "Chicago", "Houston", "Seattle"

edge_weights =
{
  ["New York", "Los Angeles"] => 2445,
  ["Los Angeles", "Chicago"] => 2015,
  ["Los Angeles", "Houston"] => 1547,
  ["Chicago", "Houston"] => 939,
  ["Seattle", "Los Angeles"] => 1548
}
edge_weights.each { |(city1, city2), w| graph.add_edge(city1, city2) }

p graph.dijkstra_shortest_path(edge_weights, "New York", "Houston")
