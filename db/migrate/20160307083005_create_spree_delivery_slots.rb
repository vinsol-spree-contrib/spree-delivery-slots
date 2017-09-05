class CreateSpreeDeliverySlots < SpreeExtension::Migration[4.2]
  def change
    create_table :spree_delivery_slots do |t|
      t.references :shipping_method, index: true
      t.string :start_time
      t.string :end_time
      t.datetime :deleted_at, index: true
      t.boolean :is_any_time_slot, default: false, null: false

      t.timestamps
    end
  end
end
