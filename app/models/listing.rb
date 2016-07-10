class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price

  validate :has_neigborhood

  def has_neigborhood
    if self.neighborhood.nil?
      errors.add(:neighborhood, "can't be blank")
    end
  end

  def average_review_rating
    self.reviews.average(:rating)
  end

end
