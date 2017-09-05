class CreateSpreeShipmentDeliverySlot < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_shipments_delivery_slots do |t|
      t.references :shipment, index: true
      t.references :delivery_slot, index: true
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
