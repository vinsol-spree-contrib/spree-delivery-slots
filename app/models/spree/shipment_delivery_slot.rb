module Spree
  class ShipmentDeliverySlot < ActiveRecord::Base
    self.table_name = 'spree_shipments_delivery_slots'

    belongs_to :delivery_slot
    belongs_to :shipment

    validates :shipment, :delivery_slot, presence: true
    validates :start_time, :end_time, presence: true, unless: :is_any_time_slot?
    validates :shipment_id, uniqueness: { scope: :delivery_slot_id }, allow_nil: true

    delegate :is_any_time_slot?, to: :delivery_slot, allow_nil: true

    before_save :verify_shipping_method
    before_validation :ensure_start_and_end_time, if: :delivery_slot_id_changed?

    def delivery_slot
      Spree::DeliverySlot.unscoped { super }
    end

    def start_time
      self[:start_time].try(:in_time_zone)
    end

    def end_time
      self[:end_time].try(:in_time_zone)
    end

    private
      def ensure_start_and_end_time
        if delivery_slot
          self.start_time = delivery_slot.start_time
          self.end_time = delivery_slot.end_time
        else
          self.start_time = self.end_time = nil
        end
      end

      def verify_shipping_method
        if shipment.shipping_method != delivery_slot.shipping_method
          self.errors.add(:delivery_slot_id, :not_valid)
        end
      end
  end
end
