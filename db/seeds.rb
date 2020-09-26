puts "Cleaning the DB"

if Rails.env == "development"
  City.destroy_all
  Transportation.destroy_all
end

puts "Fetching cities"

cities = WebscraperService::Cities.fetch

puts "Creating cities"

cities.each do |city_name|
  city = City.find_or_create_by! name: city_name
  puts "Fetching transportations for #{city_name}"
  transportations = WebscraperService::Transportations.fetch(city_name)

  transportations.each do |transportation|
    means = transportation[:means]
    transportation[:destinations].each do |destination|
      puts "Creating #{transportation[:means]} transportations from #{city_name} to #{destination[:destination_city]}"
      
      destination_city = City.find_or_create_by! name: destination[:destination_city]

      Transportation.create!(from_city: city, to_city: destination_city, means: means)
      
    end
  end
end



puts "Done!"