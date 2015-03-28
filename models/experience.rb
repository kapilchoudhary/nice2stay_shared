class Experience < ActiveRecord::Base
  has_and_belongs_to_many :accommodations, join_table: "accommodations_experiences"

  translates :name
  globalize_accessors
  
end
