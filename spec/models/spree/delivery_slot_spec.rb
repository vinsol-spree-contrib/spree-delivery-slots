require 'spec_helper'

module Spree
  describe DeliverySlot do
    let(:delivery_slot_enabled_shipping_method) { create(:shipping_method, is_delivery_slots_enabled: true) }
    let(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }

    describe 'Associations' do
      it { is_expected.to belong_to(:shipping_method).inverse_of(:delivery_slots) }
    end

    describe 'Validations' do
      it { is_expected.to validate_presence_of :start_time }
      it { is_expected.to validate_presence_of :end_time }
      it { is_expected.to validate_presence_of :shipping_method }
    end

    describe '#start_time' do
      before do
        delivery_slot.start_time = '02:00'
      end

      it { expect(delivery_slot.start_time).to eq(delivery_slot[:start_time].try(:in_time_zone)) }
    end

    describe '#end_time' do
      before do
        delivery_slot.end_time = '02:00'
      end

      it { expect(delivery_slot.end_time).to eq(delivery_slot[:end_time].try(:in_time_zone)) }
    end
  end
end
