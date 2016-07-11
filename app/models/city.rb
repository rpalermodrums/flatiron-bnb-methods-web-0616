class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :neighborhoods

  def city_openings(date1, date2)
    self.listings.joins(host: :reservations).where.not('reservations.checkin >= ? and reservations.checkout <= ?', date1, date2)
  end

  def self.highest_ratio_res_to_listings
    city_listings = self.all.joins(:listings).group('city_id').count
    city_reservations = self.all.joins(:reservations).group('city_id').count
    max = city_listings.max_by { |city, val| city_reservations[city].fdiv(val) }
    find(max.first)
  end

  def self.most_res
    city_reservations = self.all.joins(:reservations).group('city_id').count
    find(city_reservations.max_by{|k, v| v}.first)
  end

end
