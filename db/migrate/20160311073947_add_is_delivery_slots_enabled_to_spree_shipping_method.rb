class AddIsDeliverySlotsEnabledToSpreeShippingMethod < ActiveRecord::Migration
  def change
    add_column :spree_shipping_methods, :is_delivery_slots_enabled, :boolean, default: false, null: false
  end
end
