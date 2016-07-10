class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :neighborhoods

  def city_openings(date1, date2)
    listings.joins(host: :reservations).where.not('reservations.checkin >= ? and reservations.checkout <= ?', date1, date2)
  end

  def self.highest_ratio_res_to_listings
    city_listings = self.all.each_with_object({}) do |city, city_listings|
      city_listings[city.name] = city.listings.count
    end
    city_reservations = self.all.each_with_object({}) do |city, city_reservations|
      city_reservations[city.name] = city.reservations.count
    end
    highest_ratio = 0
    highest_ratio_name = ""
    city_listings.keys.each do |key|
      if city_reservations[key].fdiv(city_listings[key]) > highest_ratio
        highest_ratio = city_reservations[key].fdiv(city_listings[key])
        highest_ratio_name = key
      end
    end
    find_by(name: highest_ratio_name)
  end

  def self.most_res
    highest_city = self.all.joins(:reservations).group('cities.name').count.max_by{|k, v| v}.first
    find_by(name: highest_city)
  end

  def method_name

  end
end
