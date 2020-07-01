## `delivery_slot_id` should be need to assign before `selected_shipping_rate_id`
## because `selected_shipping_rate_id` also saves shipment.

module SpreeDeliverySlots::PermittedAttributesDecorator

  def self.prepended(base)

    base.shipment_attributes.unshift(:delivery_slot_id)
  end
end

Spree::PermittedAttributes.prepend SpreeDeliverySlots::PermittedAttributesDecorator
