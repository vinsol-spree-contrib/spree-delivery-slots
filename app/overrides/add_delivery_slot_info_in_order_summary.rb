Deface::Override.new(virtual_path: 'spree/shared/_order_details',
  name: 'add_sale_price_to_product_edit',
  replace: "[data-hook='order-shipment']",
  partial: 'spree/shared/shipment_details')
