class Accommodation < ActiveRecord::Base
  extend Enumerize

  self.inheritance_column = :_disabled

  attr_accessor :create_by_businessowner

  belongs_to :region
  belongs_to :user, class_name: AdminUser
  belongs_to :business_owner

  # To manage inactive booking requests
  has_many :booking_requests

  has_many :bookings, -> { uniq }, through: :booking_accommodations
  has_many :booking_accommodations, dependent: :destroy
  has_many :houseowner_accommodations, -> { includes(:booking).where(bookings: { by_houseowner: true }) }, class_name: 'BookingAccommodation'
  has_many :customer_accommodations, -> { includes(:booking).where(bookings: { by_houseowner: false }) }, class_name: 'BookingAccommodation'
  has_many :option_accommodations, dependent: :destroy
  has_many :descriptions, dependent: :destroy, class_name: 'AccommodationDescription'

  has_many :accommodation_inquiries
  has_many :inquiries, through: :accommodation_inquiries

  has_many :not_available_days
  accepts_nested_attributes_for :not_available_days, allow_destroy: true

  accepts_nested_attributes_for :descriptions, allow_destroy: true

  has_and_belongs_to_many :leads

  validates :region, :name, :type, presence: true
  validates :user, presence: true, :unless => :create_by_businessowner

  enumerize :type, in: %i{villa apartment bb}

  translates :title, :meta_desc

  def display_name
    @display_name ||= "#{name} #{type_text}"
  end

  def description(locale)
    descriptions.find_by_locale(locale) || descriptions.find_by_locale('en') || nil
  end

  def created_by_houseowner
    self.created_by == BookingAccommodation::CREATED_BY[:houseowner]
  end
end
