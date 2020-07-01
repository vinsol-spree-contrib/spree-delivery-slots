module SpreeDeliverySlots::ShipmentDecorator

  def self.prepended(base)

    base.belongs_to :delivery_slot

    base.delegate :is_delivery_slots_enabled?, to: :shipping_method, allow_nil: true

    base.validate :verify_delivery_slot, if: [:is_delivery_slots_enabled?, :delivery_slot]

    base.before_save :ensure_valid_delivery_slot, if: :delivery_slot
  end

  def delivery_slot
    Spree::DeliverySlot.unscoped { super }
  end

  def delivery_slot_time_frame
    delivery_slot ? delivery_slot.time_frame : Spree.t(:any_time)
  end

  private
    def ensure_valid_delivery_slot
      unless is_delivery_slots_enabled?
        self.delivery_slot_id = nil
      end
    end

    def verify_delivery_slot
      if delivery_slot.shipping_method != shipping_method
        self.errors.add(:delivery_slot_id, :should_belongs_to_correct_shipping_method)
      end
    end
end

Spree::Shipment.prepend SpreeDeliverySlots::ShipmentDecorator
