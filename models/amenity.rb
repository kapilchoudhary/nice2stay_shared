class Amenity < ActiveRecord::Base
  has_and_belongs_to_many :accommodations, join_table: "accommodations_amenities"
  translates :name
  globalize_accessors


  def self.get_for_search_filter
    Amenity.find_by_sql("
     select amenities.* ,count(accommodations_amenities.amenity_id) as accommodations_count
     from amenities
     left join accommodations_amenities on accommodations_amenities.amenity_id = amenities.id 
     where amenities.add_to_search_filters = true 
     OR (SELECT count(*) FROM accommodations_amenities WHERE  accommodations_amenities.amenity_id = amenities.id) > 0
     group by amenities.id
     order by accommodations_count desc;")
  end
  
  
end
