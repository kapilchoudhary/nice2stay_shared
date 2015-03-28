class CustomText < ActiveRecord::Base
  translates :h1_text, :p_text, :meta_title, :meta_description
  belongs_to :country
  belongs_to :region
  belongs_to :category
  belongs_to :experience, :foreign_key => "tag_id"
  
  def self.get_custom_text(category_id=nil,country_id=nil, region_id=nil,tag_id=nil)
    query = ""
    query << ((category_id.blank?) ? "category_id IS ?" : "category_id = ?")
    query << ((country_id.blank?) ? " and country_id IS ?" : " and country_id = ?")
    query << ((region_id.blank?) ? " and region_id IS ?" : " and region_id = ?" )
    query << ((tag_id.blank?) ? " and tag_id IS ?" : " and tag_id = ?")
    where(query, category_id,country_id,region_id,tag_id)
  end
  
end
