class Region < ActiveRecord::Base
  has_many :accommodations, dependent: :restrict_with_error
  has_many :bookings, dependent: :restrict_with_error, through: :accommodations

  validates :name, presence: true

  translates :name, :content
  globalize_accessors
end
