class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host?
    self.listings.any? {|listing| listing.host_id == id}
  end

  def guests
    self.listings.map(&:guests).first.uniq if self.host?
  end

  def hosts
    trips.map(&:listing).map(&:host).uniq unless self.host?
  end

  def host_reviews
    listings.map(&:reviews).first if self.host?
  end
end
