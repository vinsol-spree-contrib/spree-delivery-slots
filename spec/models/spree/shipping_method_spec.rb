require 'spec_helper'

module Spree
  describe ShippingMethod do
    describe 'Associations' do
      it { is_expected.to have_many(:delivery_slots).inverse_of(:shipping_method).dependent(:destroy) }
    end

    describe 'Accepts nested attributes for' do
      it { is_expected.to accept_nested_attributes_for(:delivery_slots).allow_destroy(true) }
    end

    describe 'Callbacks' do
      describe '#build_any_time_delivery_slot' do
        let(:shipping_category) { create(:shipping_category) }
        context 'delivery slot is enabled' do
          let(:shipping_method) { build(:shipping_method, is_delivery_slots_enabled: true) }
          let(:any_time_delivery_slot) { shipping_method.delivery_slots.any_time.build(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }

          context 'any time delivery slot is present' do
            before do
              shipping_method.shipping_categories << shipping_category
              any_time_delivery_slot
            end

            subject { shipping_method.delivery_slots.select(&:is_any_time_slot?) }

            it 'expects to not create new any time delivery slot' do
              expect { shipping_method.save! }.to_not change { subject.first }
            end

            it 'expects to have only one any time delivery slot' do
              shipping_method.save!
              expect(subject.size).to eq 1
            end
          end

          context 'any time delivery slot is absent' do
            before do
              shipping_method.shipping_categories << shipping_category
            end

            def any_time_slots
            end

            subject { shipping_method.delivery_slots.select(&:is_any_time_slot?) }

            it 'expects to create new any time delivery slot' do
              expect { shipping_method.save! }.to change { subject.first }.from(nil)
            end

            it 'expects to have only one any time delivery slot' do
              shipping_method.save!
              expect(subject.size).to be 1
            end
          end
        end

        context 'delivery slot is not enabled' do
          let(:shipping_method) { build(:shipping_method, is_delivery_slots_enabled: false) }
          let(:any_time_delivery_slot) { shipping_method.delivery_slots.any_time.build(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }

          context 'any time delivery slot is present' do
            before do
              shipping_method.shipping_categories << shipping_category
              any_time_delivery_slot
            end

            subject { shipping_method.delivery_slots.select(&:is_any_time_slot?) }

            it 'expects to not create new any time delivery slot' do
              expect(subject.first).to eq(any_time_delivery_slot)
              shipping_method.save!
              expect(subject.first).to eq(any_time_delivery_slot)
            end

            it 'expects to have only one any time delivery slot' do
              shipping_method.save!
              expect(subject.size).to be 1
            end
          end

          context 'any time delivery slot is absent' do
            before do
              shipping_method.shipping_categories << shipping_category
            end

            subject { shipping_method.delivery_slots.select(&:is_any_time_slot?) }

            it 'expects to not create new any time delivery slot' do
              expect(subject.first).to be nil
              shipping_method.save!
              expect(subject.first).to be nil
            end

            it 'expects to have no any time delivery slot' do
              shipping_method.save!
              expect(subject.size).to be_zero
            end
          end
        end
      end
    end
  end
end
