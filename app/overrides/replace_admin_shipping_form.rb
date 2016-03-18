Deface::Override.new(virtual_path: 'spree/admin/orders/_shipment',
  name: 'replace_admin_shipping_form',
  replace: "[data-hook='admin_shipment_form']",
  partial: 'spree/admin/orders/shipment_custom_form')
