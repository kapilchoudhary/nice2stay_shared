class PlaceCategory < ActiveRecord::Base
  has_many :places, dependent: :destroy
  translates :name
  globalize_accessors
  
  scope :find_place, ->(ids) { where(:id => ids) }
end
