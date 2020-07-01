Deface::Override.new(virtual_path: 'spree/orders/show',
  name: 'add_sale_price_to_product_edit',
  replace: "dl>div:nth-of-type(3)",
  partial: 'spree/orders/shipment_details')
