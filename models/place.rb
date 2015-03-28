class Place < ActiveRecord::Base
  has_one :location, as: :trackable, dependent: :destroy
  accepts_nested_attributes_for :location
  
  belongs_to :country
  belongs_to :region
  belongs_to :place_category
  
  translates :details, :description
  
  scope :country_filter, ->(ids) { where("country_id IN (?)", ids)}
  scope :region_filter, ->(ids) { where("region_id IN (?)", ids)}
  
  def self.get_location(keys)
    rtn = {} 
    places = self.includes(:location).where("places.id IN (?)", keys)
    places.each do |pl|
      rtn["30km"] = { lat: pl.location.lat, lon: pl.location.lon }
    end
    return rtn
  end
  
  def full_address
    "#{address } #{region.try(:name_en)} #{country.try(:name_en)}"
  end
end

#locations => { "10km" => { lat: 40.12, lon: -71.30} ,"20km" => { lat: 40.12, lon: -71.30 } }
