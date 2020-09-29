puts "Cleaning the DB"

if Rails.env == "development"
  City.destroy_all
  Transportation.destroy_all
end

puts "Fetching cities"

cities_names = WebscraperService::Cities.fetch

puts "Creating cities"

cities = []
cities_names.each do |city_name|
  cities << City.find_or_create_by!(name: city_name)
end

cities.each do |city|
  
  puts "Fetching transportations for #{city.name}"
    transportations = WebscraperService::Transportations.fetch(city.name)
  
    transportations.each do |transportation|
      means = transportation[:means]
      transportation[:destinations].each do |destination|
        
        destination_city = City.find_by_name destination[:destination_city]
        if destination_city
          puts "Creating #{transportation[:means]} transportations from #{city.name} to #{destination[:destination_city]}"
          
          Transportation.create!(
            from_city: city, 
            to_city: destination_city, 
            means: means,
            npc_name: destination[:npc_name],
            price: destination[:price]
          )
        else
          puts destination[:destination_city] + " is not a valid destination city."
        end
        
      end
    end

end

puts "Creating transportations for the cities that the scraper wasn't enough"

def create_transportations(origin_city_name, cities_infos, means, npc_name, vice_versa = false)
  origin_city = City.find_by_name origin_city_name
  cities_infos.each do |city_info|
    puts "Creating #{means} transportations from #{origin_city_name} to #{city_info[:city_name]}"
    destination_city = City.find_by_name city_info[:city_name]
    Transportation.create!(
      from_city: origin_city, 
      to_city: destination_city, 
      npc_name: npc_name, 
      price: city_info[:price],
      means: means
    )
    if vice_versa
      Transportation.create!(
        from_city: destination_city, 
        to_city: origin_city, 
        npc_name: npc_name, 
        price: city_info[:price],
        means: means
      )
    end
  end
end

puts "Creating transportations for Gray Beach"
cities_infos = [
  {city_name: "Ab'Dendriel", price: 160},
  {city_name: "Darashia", price: 160},
  {city_name: "Edron", price: 150},
  {city_name: "Venore", price: 150},
     
]
npc_name = 'NPC Scrutinon'
create_transportations("Gray Beach", cities_infos, 'boat', npc_name, true)


puts "Creating transportations for Krailos"
cities_infos = [
  {city_name: 'Venore' ,price: 110},
  {city_name: 'Edron' ,price: 100},
  {city_name: 'Rathleton' ,price: 110},
  {city_name: 'Darashia' ,price: 110}
]
npc_name = 'NPC Captain Pelagia'
create_transportations("Krailos", cities_infos, 'boat', npc_name)

puts "Creating transportations for Rathleton"
cities_infos = [
  {city_name: 'Thais' ,price: 150},
  {city_name: 'Edron' ,price: 110},
  {city_name: 'Port Hope' ,price: 200},
  {city_name: 'Venore' ,price: 130}
]
npc_name = 'Captain Gulliver'
create_transportations("Rathleton", cities_infos, 'boat', npc_name)

puts "Creating transportations for Roshamuul"
cities_infos = [
  {city_name: 'Thais' ,price: 210}
]
npc_name = 'Captain Gulliver'
create_transportations("Roshamuul", cities_infos, 'boat', npc_name)



puts "Done!"
