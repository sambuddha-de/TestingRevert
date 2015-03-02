class HackRate < ActiveRecord::Base
  validates_length_of :sysaddress, :maximum => 50
end
