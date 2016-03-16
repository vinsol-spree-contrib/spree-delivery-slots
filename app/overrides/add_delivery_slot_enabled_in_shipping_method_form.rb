Deface::Override.new(virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'add_delivery_slot_enabled_in_shipping_method_form',
  insert_after: "[data-hook='admin_shipping_method_form_display_field']",
  partial: 'spree/admin/shipping_methods/delivery_slot_enabled_field')

Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'modify_shipping_method_form_display_field',
  set_attributes: '[data-hook=admin_shipping_method_form_display_field]',
  attributes: { class: 'col-md-4' })

Deface::Override.new(
  virtual_path: 'spree/admin/shipping_methods/_form',
  name: 'modify_shipping_method_form_name_field',
  set_attributes: '[data-hook=admin_shipping_method_form_name_field]',
  attributes: { class: 'col-md-4' })
