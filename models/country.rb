class Country < ActiveRecord::Base
  has_many :regions, dependent: :destroy
  has_many :accommodations, dependent: :destroy
  after_update { self.accommodations.each(&:touch) }

  translates :name, :content
  globalize_accessors

  def region_names
    regions.map(&:name)
  end
end
