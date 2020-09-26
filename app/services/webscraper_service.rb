require 'open-uri'
require 'nokogiri'

class WebscraperService
  module Cities
    def self.fetch_cities
      url = "https://www.tibiawiki.com.br/wiki/cidades"
      
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      
      cities = html_doc.search('#toc li li').map {|e| e.text.strip.gsub(/[^a-zA-Z]/, '') }
      
    end
  end
end