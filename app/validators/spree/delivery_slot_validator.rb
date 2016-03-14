module Spree
  class DeliverySlotValidator < ActiveModel::Validator
    def validate(delivery_slot)
      if delivery_slot.shipping_method.delivery_slots.detect { |other_delivery_slot| !other_delivery_slot.is_any_time_slot? && (delivery_slot != other_delivery_slot) && delivery_slot.overlaps_with?(other_delivery_slot) }
        delivery_slot.errors.add(:base, :overlapping_start_time_and_end_time)
      end
    end
  end
end
