Spree::ShippingMethod.class_eval do
  has_many :delivery_slots, dependent: :destroy, inverse_of: :shipping_method

  accepts_nested_attributes_for :delivery_slots, allow_destroy: true, reject_if: :all_blank

  before_save :build_any_time_delivery_slot, if: [:is_delivery_slots_enabled?, :any_time_delivery_slot_absent?]

  private
    def build_any_time_delivery_slot
      self.delivery_slots.any_time.build
    end

    def any_time_delivery_slot_absent?
      delivery_slots.any_time.empty?
    end
end
