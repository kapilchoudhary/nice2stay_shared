class Accommodation < ActiveRecord::Base
  include AccommodationExtention
  extend Enumerize

  self.inheritance_column = :_disabled

  enumerize :type, in: %i{villa apartment bb}

  belongs_to :region
  translates :title, :meta_desc
end
