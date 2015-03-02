class Location < ActiveRecord::Base
  validates :name, :presence => true
  #validates :position, :presence => true, numericality: { only_integer: true, message: "Not a valid position." }
end
