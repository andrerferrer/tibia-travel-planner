class TransportationsController < ApplicationController
  def index
    @cities = City.order name: :asc
    if params[:search].present?
      origin_city = City.find(params[:search][:origin])
      destination_city = City.find(params[:search][:destination])
      @transportations = origin_city.route_to(destination_city)
    end
  end
end
