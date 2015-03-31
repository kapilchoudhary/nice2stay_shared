class Customer < ActiveRecord::Base
  has_many :bookings, dependent: :destroy
  has_many :booking_accommodations, through: :bookings
  has_many :booked_accommodations, through: :booking_accommodations, source: :accommodation
  has_many :options, dependent: :destroy
  has_many :leads, dependent: :destroy

  belongs_to :country,  touch: true

  validates :surname, :name, presence: true

  validates :name, uniqueness: { scope: :surname }

  scope :with_statistics, -> do
    joins(%q(LEFT OUTER JOIN "bookings" ON "bookings"."customer_id" = "customers"."id" LEFT OUTER JOIN "booking_accommodations" ON "booking_accommodations"."booking_id" = "bookings"."id")).
    select("customers.*, sum(booking_accommodations.rental_price) as total_rent, sum(booking_accommodations.commission) as total_commission").
    group('customers.id')
  end

  def full_name
    "#{name} #{surname}".try(:humanize)
  end

  def full_address
    "#{address} - #{city} - #{country} - #{zip}"
  end

  LANGUAGE = ['NL', 'EN']
end
