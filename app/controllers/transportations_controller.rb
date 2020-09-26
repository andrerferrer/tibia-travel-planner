class TransportationsController < ApplicationController
  def index
    @cities = City.all
    if params[:search].present?
      origin_city = City.find(params[:search][:origin])
      destination_city = City.find(params[:search][:destination])
      @transportations = origin_city.route_to(destination_city)
    end
  end
end
