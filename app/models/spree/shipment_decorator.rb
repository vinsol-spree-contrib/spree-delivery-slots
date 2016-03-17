Spree::Shipment.class_eval do
  belongs_to :delivery_slot

  delegate :is_delivery_slots_enabled?, to: :shipping_method, allow_nil: true

  validate :verify_delivery_slot, if: [:is_delivery_slots_enabled?, :delivery_slot]

  before_save :ensure_valid_delivery_slot, if: :delivery_slot

  def delivery_slot
    Spree::DeliverySlot.unscoped { super }
  end

  def delivery_slot_time_frame
    delivery_slot ? delivery_slot.time_frame : Spree.t(:any_time)
  end

  private
    def ensure_valid_delivery_slot
      if shipping_method != delivery_slot.shipping_method
        self.delivery_slot_id = nil
      end
    end

    def verify_delivery_slot
      if delivery_slot.shipping_method != shipping_method
        self.errors.add(:delivery_slot_id, :should_belongs_to_correct_shipping_method)
      end
    end
end
