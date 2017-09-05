class AddDeliverySlotReferenceToSpreeShipment < SpreeExtension::Migration[4.2]
  def change
    add_reference :spree_shipments, :delivery_slot, index: true
  end
end
