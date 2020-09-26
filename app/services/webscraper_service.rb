require 'open-uri'
require 'nokogiri'

class WebscraperService
  module Cities
    def self.fetch
      url = "https://www.tibiawiki.com.br/wiki/cidades"
      
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      
      cities = html_doc.search('#toc li li').map {|e| e.text.gsub(/[^\w' ]|[0-9]/, '').strip }
      
    end
  end
  module Transportations
    def self.fetch(city_name)
      city_name = city_name.gsub(' ', '%20')
      url = "https://www.tibiawiki.com.br/wiki/#{city_name}"
      
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      
      
      html_doc.search('#tabelaDPL:not(.sortable)')
              .map do |table|
                transportation_means = find_means(table.search('td div').text)
                if transportation_means
                  {
                    means: transportation_means,
                    destinations: build_transportations(table, city_name)
                  }
                end
              end
              .compact
    end

    class << self

      def find_means(text)
        return 'steamship' if text =~ /\bsteamship\b/i
        return 'boat' if text =~ /\bbarco\b/i
        return 'magic carpet' if text =~ /\bTapete Mágico\b/i
        return nil
      end

      def build_transportations(table, city_name)
        npc_name_regex = /^(.+)pode te levar/
        npc_name = table.search('td div')
        .text
        .match(npc_name_regex)[1]
        .strip
        
        destinations_and_prices = table.search('ul')
                                      .text
                                      .split("\n")
                                      .filter{ |string| string =~ /gp/ }

        destinations_and_prices.map do |destination_and_price|
          destination_and_price = destination_and_price.match(/(.+?)(\d+ *gps?)/)
          destination = destination_and_price[1].gsub(/[^A-Za-z| ]/, '').strip
          price = destination_and_price[2].gsub(/\s/, '')

          {
            origin: city_name,
            npc_name: npc_name,
            destination_city: destination,
            price: price
          }
        end
      end

    end

  end
end

          # WebscraperService::Transportations.fetch('kazordoon')
