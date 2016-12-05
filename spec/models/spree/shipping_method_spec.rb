require 'spec_helper'

module Spree
  describe ShippingMethod do
    describe 'Associations' do
      it { is_expected.to have_many(:delivery_slots).inverse_of(:shipping_method).dependent(:destroy) }
    end

    describe 'Accepts nested attributes for' do
      it { is_expected.to accept_nested_attributes_for(:delivery_slots).allow_destroy(true) }
    end

    describe '#delivery_slots_time_frames' do
      let!(:delivery_slot_enabled_shipping_method) { create(:shipping_method, is_delivery_slots_enabled: true) }
      let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
      let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

      subject do
        delivery_slot_enabled_shipping_method.delivery_slots.reload
        delivery_slot_enabled_shipping_method.delivery_slots_time_frames
      end

      it { is_expected.to include([delivery_slot1.time_frame, delivery_slot1.id]) }
      it { is_expected.to include([delivery_slot2.time_frame, delivery_slot2.id]) }
      it { is_expected.to include([Spree.t(:any_time), nil]) }
    end
  end
end
