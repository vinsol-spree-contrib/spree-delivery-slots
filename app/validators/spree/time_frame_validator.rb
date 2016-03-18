module Spree
  class TimeFrameValidator < ActiveModel::Validator
    def validate(delivery_slot)
      if delivery_slot.start_time >= delivery_slot.end_time
        delivery_slot.errors.add(:start_time, :less_than_end_time)
      end
    end
  end
end
