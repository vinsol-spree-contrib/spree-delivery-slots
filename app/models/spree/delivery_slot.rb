module Spree
  class DeliverySlot < ActiveRecord::Base
    acts_as_paranoid

    belongs_to :shipping_method, inverse_of: :delivery_slots

    validates :shipping_method, :start_time, :end_time, presence: true
    validates_with ::Spree::TimeFrameValidator, unless: :deleted?, if: [:start_time?, :end_time?]
    validates_with ::Spree::DeliverySlotUniqueValidator, unless: :deleted?, if: [:start_time?, :end_time?]

    before_update :create_duplicate_delivery_slot, if: :time_changed?
    before_update :reload_and_set_deleted_at, if: :time_changed?

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
      "#{ start_time.strftime('%I:%M %P') } - #{ end_time.strftime('%I:%M %P') }"
    end

    private
      def create_duplicate_delivery_slot
        new_delivery_slot = self.dup
        new_delivery_slot.save(validate: false)
      end

      def reload_and_set_deleted_at
        self.reload
        self.deleted_at = Time.current
      end

      def time_changed?
        start_time_changed? || end_time_changed?
      end
  end
end
