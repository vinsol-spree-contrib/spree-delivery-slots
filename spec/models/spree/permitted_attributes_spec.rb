require 'spec_helper'

module Spree
  describe PermittedAttributes do
    describe '.shipment_attributes' do
      subject { Spree::PermittedAttributes.shipment_attributes }

      it { is_expected.to include(:delivery_slot_id) }
    end
  end
end
