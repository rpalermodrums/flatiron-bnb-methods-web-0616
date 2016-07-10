class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation

  validate :has_reseservation

  def has_reseservation
    return if guest.nil?
    return if reservation.nil?
    # binding.pry
    if guest.trips.nil? || guest.trips.last.checkout <= reservation.checkout
      # binding.pry
      errors.add(:review, "can't be added without a completed stay")
    end
  end

end
