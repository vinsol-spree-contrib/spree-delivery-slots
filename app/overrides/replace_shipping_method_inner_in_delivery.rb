Deface::Override.new(virtual_path: 'spree/checkout/_delivery',
  name: 'replace_shipping_method_inner_in_delivery',
  replace: "[data-hook=shipping_method_inner]",
  partial: 'spree/checkout/shipping_method_inner')
