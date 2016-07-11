class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :trip, :class_name => "Reservation"
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :neighborhood, through: :listing
  has_one :city, through: :neighborhood

  validates_presence_of :checkin, :checkout

  validate :not_hosts_rental, :listing_available, :checkin_before_checkout

  def not_hosts_rental
    if listing.host_id == guest_id
      errors.add(:guest, "can't own rental")
    end
  end

  def listing_available
    unless nil_checkin_or_checkout || not_open?
      errors.add(:listing, "can't be booked")
    end
  end

  def checkin_before_checkout
    unless nil_checkin_or_checkout || checkin < checkout
      errors.add(:listing, "can only be booked if checkin is before checkout")
    end
  end

  def nil_checkin_or_checkout
    checkin.nil? || checkout.nil?
  end

  def not_open?
    listing.reservations.none? do |res|
      res.checkin > checkout || checkin < res.checkout
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    listing.price.to_f * duration
  end
end
