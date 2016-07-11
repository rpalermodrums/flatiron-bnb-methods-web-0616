class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    city.city_openings(date1, date2).where(neighborhood: self)
  end

  def self.highest_ratio_res_to_listings
    reservations = all.joins(:reservations).group('neighborhood_id').count
    listings = all.joins(:listings).group('neighborhood_id').count
    find(reservations.max_by {|k, v| v.fdiv(listings[k])}.first)
  end

  def self.most_res
    res_count = all.joins(:reservations).group('neighborhood_id').count
    find(res_count.max_by {|k, v| v }.first)
  end

end
