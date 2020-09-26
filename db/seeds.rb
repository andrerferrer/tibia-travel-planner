puts "Clean the DB"

if Rails.env == "development"
  City.destroy_all
end

puts "Fetch cities"

cities = WebscraperService::Cities.fetch

puts "Create cities"

cities.each do |city|
  City.create! name: city
end

puts "Done!"