class Location < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  
  geocoded_by :address, :latitude  => :lat, :longitude => :lon
  
  #after_validation :geocode
  before_save :geocode
  
  def latlong
    "#{lat}, #{lon}"
  end
  
  def address
    trackable.full_address
  end
  
end
