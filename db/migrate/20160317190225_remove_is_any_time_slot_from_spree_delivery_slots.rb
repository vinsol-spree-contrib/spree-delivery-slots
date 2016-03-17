class RemoveIsAnyTimeSlotFromSpreeDeliverySlots < ActiveRecord::Migration
  def up
    remove_column :spree_delivery_slots, :is_any_time_slot
  end

  def down
    add_column :spree_delivery_slots, :is_any_time_slot, :boolean, default: false, null: false
  end
end
