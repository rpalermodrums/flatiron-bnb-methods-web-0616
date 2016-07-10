class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host?
    self.listings.any? {|listing| listing.host_id == id}
  end

  def guests
    if self.host?
      self.listings.each_with_object([]) do |listing, a|
        a << listing.guests
      end.flatten.uniq
    end
  end

  def hosts
    unless self.host?
      # binding.pry
      self.trips.each_with_object([]) do |trip, a|
        a << trip.listing.host
      end.flatten.uniq
    end
  end

  def host_reviews
    if self.host?
      self.reservations.each_with_object([]) do |res, a|
        a << res.review
      end
    end
  end

end
