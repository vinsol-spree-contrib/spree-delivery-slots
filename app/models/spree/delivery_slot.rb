module Spree
  class DeliverySlot < ActiveRecord::Base
    acts_as_paranoid

    belongs_to :shipping_method, inverse_of: :delivery_slots

    validates :shipping_method, :start_time, :end_time, presence: true
    validates_with ::Spree::DeliverySlotValidator, unless: :deleted?, if: [:start_time?, :end_time?]

    scope :any_time, -> { where(is_any_time_slot: true) }
    scope :not_any_time, -> { where(is_any_time_slot: false) }

    def start_time
      self[:start_time].try(:in_time_zone)
    end

    def end_time
      self[:end_time].try(:in_time_zone)
    end

    def overlaps_with?(other_delivery_slot)
      (other_delivery_slot.start_time < end_time) &&
      (start_time < other_delivery_slot.end_time)
    end

    def time_frame
      if is_any_time_slot?
        'Any Time'
      else
        "#{ start_time.strftime('%I:%M %P') } - #{ end_time.strftime('%I:%M %P') }"
      end
    end
  end
end
