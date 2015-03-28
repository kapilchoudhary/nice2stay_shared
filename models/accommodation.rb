class Accommodation < ActiveRecord::Base
  include AccommodationExtention
  extend Enumerize

  self.inheritance_column = :_disabled

  enumerize :type, in: %i{villa apartment bb}
end
