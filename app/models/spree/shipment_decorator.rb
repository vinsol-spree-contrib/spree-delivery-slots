Spree::Shipment.class_eval do
  has_one :shipment_delivery_slot, dependent: :destroy, inverse_of: :shipment
  has_one :delivery_slot, through: :shipment_delivery_slot

  accepts_nested_attributes_for :shipment_delivery_slot, update_only: true, reject_if: :all_blank

  delegate :is_delivery_slots_enabled?, to: :shipping_method, allow_nil: true

  validates_associated :shipment_delivery_slot, if: :is_delivery_slots_enabled?

  before_save :ensure_shipment_delivery_slot_if_required

  private
    def ensure_shipment_delivery_slot_if_required
      if is_delivery_slots_enabled? && !shipment_delivery_slot
        ensure_shipment_delivery_slot
      end
    end

    def ensure_shipment_delivery_slot
      any_time_delivery_slot = shipping_method.delivery_slots.any_time.first
      self.build_shipment_delivery_slot(delivery_slot: any_time_delivery_slot)
    end
end
