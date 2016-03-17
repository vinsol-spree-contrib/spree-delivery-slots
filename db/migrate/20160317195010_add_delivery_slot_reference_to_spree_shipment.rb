class AddDeliverySlotReferenceToSpreeShipment < ActiveRecord::Migration
  def change
    add_reference :spree_shipments, :delivery_slot, index: true
  end
end
