class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    
    city.city_openings(date1, date2).where(neighborhood: self)
  end

  def self.highest_ratio_res_to_listings
    reservations_by_neighborhood = self.all.joins(:reservations).group('name').count
    listings_by_neighborhood = self.all.joins(:listings).group('name').count
    highest_ratio = reservations_by_neighborhood.max_by do |k, v|
      reservations_by_neighborhood[k].fdiv(listings_by_neighborhood[k])
    end.first
    self.find_by(name: highest_ratio)
  end

  def self.most_res
    find_by(name: self.all.joins(:reservations).group(:name).count.max_by {|k, v| v}.first)

  end

end
