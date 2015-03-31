class Accommodation < ActiveRecord::Base
  include AccommodationExtension

  extend Enumerize
  self.inheritance_column = :_disabled
  enumerize :type, in: %i{villa apartment bb}

  belongs_to :country,  touch: true
  belongs_to :region, touch: true
  belongs_to :category, touch: true
  has_one :location, as: :trackable, dependent: :destroy
  has_and_belongs_to_many :experiences, join_table: "accommodations_experiences"

  #association for image
  has_many :images, :as => :imagable
  has_and_belongs_to_many :amenities, join_table: "accommodations_amenities"

  validates :country_id, :region_id, :category_id, presence: true
  accepts_nested_attributes_for :images, :allow_destroy => true
  accepts_nested_attributes_for :location

  serialize :place_category_name, Array

  after_create :fetch_place_category

  translates :title, :meta_desc

  globalize_accessors

  #include ElasticsearchSearchable

  RECORDS_PER_PAGE = 10
  BEDROOMS = [1,2,3,4,5,6,7,8,9,10]
  PRICE_RANGE = {1 =>'€', 2 =>'€€', 3 =>'€€€', 4 =>'Sale'}
  PRICE_RANGE_OPTION = { '€' => 1, '€€' => 2 , '€€€' => 3, 'Sale' => 4}
  CATEGORY = {
    "en" => ["villa", "apartment", "bedbreakfast"] ,
    "nl" => ["vakantiehuizen","apartementen","bedbreakfast"]
  }

  ACCOMMODATION_TYPE = {
    "en" => ["villas", "apartments", "bedbreakfasts"] ,
    "nl" => ["vakantiehuizen","apartementen","bedbreakfast"]
  }


  def country_name_en
    country.name_en rescue ""
  end

  def country_name_nl
    country.name_nl rescue ""
  end

  def region_name_en
    region.name_en rescue ""
  end

  def region_name_nl
    region.name_nl rescue ""
  end

  def category_name_en
    category.name_en rescue ""
  end

  def category_name_nl
    category.name_nl rescue ""
  end

  def tags_en
    tags.map(&:name_en)
  end

  def tags_nl
    tags.map(&:name_nl)
  end

  def full_address
    "#{address} #{region.name_en rescue ''} #{country.name_en rescue ''}"
  end

  #get accommodation experience list
  def experience_name_en
    self.experiences.collect(&:name_en)
  end

  def experience_name_nl
    self.experiences.collect(&:name_nl)
  end

  def experiences_name_list
    self.experiences.map(&:name).join(", ")
  end

  def experiences_name_list=(list)
    experiences = list.split(',')
    experiences_id = Experience.where(name: experiences).collect(&:id)
    self.experience_ids = experiences_id
  end

  #get accommodation amenities list
  def amenity_name_en
    self.amenities.collect(&:name_en)
  end

  def amenity_name_nl
    self.amenities.collect(&:name_nl)
  end

  def amenities_name_list
    self.amenities.map(&:name).join(", ")
  end

  def amenities_name_list=(list)
    amenities = list.split(',')
    amenities_id = Amenity.where(name: amenities).collect(&:id)
    self.amenity_ids = amenities_id
  end

  def fetch_place_category
    latlon = self.location
    # Need to discuss and fix this
    unless latlon.blank?
      places_ids = Location.near([latlon.lat, latlon.lon], 30).where(trackable_type: "Place").map(&:trackable_id)
      place_category = Place.where("places.id IN (?)", places_ids).map(&:place_category_id)
      self.place_category_name = place_category.uniq
      save!
    end
  end

  def place_category_en
    PlaceCategory.find_place(self.place_category_name).map(&:name_en)
  end

  def place_category_nl
    PlaceCategory.find_place(self.place_category_name).map(&:name_nl)
  end

  def suggestion
   {"input" => [country_name_en, country_name_nl, region_name_en, region_name_nl] }
  end
end
