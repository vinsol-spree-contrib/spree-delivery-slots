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

      context 'start time is less than other\'s end time' do
        context 'end time is less than other\'s start time' do
          let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 4.hours, end_time: Time.current + 5.hours) }
          let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 6.hours, end_time: Time.current + 7.hours) }

          it { expect(delivery_slot1).to be_valid }
          it { expect(delivery_slot2).to be_valid }
        end

        context 'end time is more than other\'s start time' do
          let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }
          let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 5.hours, end_time: Time.current + 7.hours) }

          it { expect(delivery_slot1).to be_invalid }
          it { expect(delivery_slot2).to be_invalid }

          it 'expect to have errors on base' do
            delivery_slot1.valid?
            expect(delivery_slot1.errors[:base]).to include(I18n.t(:overlapping_start_time_and_end_time, scope: [:activerecord, :errors, :models, 'spree/delivery_slot']))
          end

          it 'expect to have errors on base' do
            delivery_slot2.valid?
            expect(delivery_slot2.errors[:base]).to include(I18n.t(:overlapping_start_time_and_end_time, scope: [:activerecord, :errors, :models, 'spree/delivery_slot']))
          end
        end
      end

      context 'start time is more than other\'s end time' do
        context 'end time is more than other\'s start time' do
          let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 6.hours, end_time: Time.current + 7.hours) }
          let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 3.hours, end_time: Time.current + 4.hours) }

          it { expect(delivery_slot1).to be_valid }
          it { expect(delivery_slot2).to be_valid }
        end
      end

      context 'start_time is less than end time' do
        let(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

        it { expect(delivery_slot).to be_valid }
      end

      context 'start_time is more than end time' do
        let(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 6.hours, end_time: Time.current + 4.hours) }

        it { expect(delivery_slot).to be_invalid }

        it 'expect to have errors on start_time' do
          delivery_slot.valid?
          expect(delivery_slot.errors[:start_time]).to include(I18n.t(:less_than_end_time, scope: [:activerecord, :errors, :models, 'spree/delivery_slot']))
        end
      end

      context 'start_time is equal to end time' do
        let(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 4.hours, end_time: Time.current + 4.hours) }

        it { expect(delivery_slot).to be_invalid }

        it 'expect to have errors on start_time' do
          delivery_slot.valid?
          expect(delivery_slot.errors[:start_time]).to include(I18n.t(:less_than_end_time, scope: [:activerecord, :errors, :models, 'spree/delivery_slot']))
        end
      end
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

    describe '#time_frame' do
      it { expect(delivery_slot.time_frame).to eq "#{ I18n.l(delivery_slot.start_time, format: :frame_time) } - #{ I18n.l(delivery_slot.end_time, format: :frame_time) }" }
    end

    describe '#overlaps_with?' do
      context 'start time is less than other\'s end time' do
        context 'end time is less than other\'s start time' do
          let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 4.hours, end_time: Time.current + 5.hours) }
          let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 6.hours, end_time: Time.current + 7.hours) }

          it { expect(delivery_slot1).to_not be_overlaps_with delivery_slot2 }
          it { expect(delivery_slot1).to_not be_overlaps_with delivery_slot2 }
        end

        context 'end time is more than other\'s start time' do
          let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }
          let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 5.hours, end_time: Time.current + 7.hours) }

          it { expect(delivery_slot1).to be_overlaps_with delivery_slot2 }
          it { expect(delivery_slot1).to be_overlaps_with delivery_slot2 }
        end
      end

      context 'start time is more than other\'s end time' do
        context 'end time is more than other\'s start time' do
          let!(:delivery_slot1) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 6.hours, end_time: Time.current + 7.hours) }
          let!(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.build(start_time: Time.current + 3.hours, end_time: Time.current + 4.hours) }

          it { expect(delivery_slot1).to_not be_overlaps_with delivery_slot2 }
          it { expect(delivery_slot1).to_not be_overlaps_with delivery_slot2 }
        end
      end
    end

    describe '#callbacks' do
      describe '#create_duplicate_delivery_slot' do
        context 'start time changed' do
          let(:new_start_time) { delivery_slot.start_time + 1.minute }

          before do
            delivery_slot.start_time = new_start_time
          end

          subject { Spree::DeliverySlot.last }

          it 'expects to create new delivery slot' do
            expect { delivery_slot.save! }
              .to change { Spree::DeliverySlot.unscoped.count }.by(1)
          end

          it 'expects new object to have changed start_time' do
            delivery_slot.save!
            expect(subject.start_time).to eq new_start_time
          end

          it 'expects new object to have same end_time' do
            delivery_slot.save!
            expect(subject.end_time).to eq delivery_slot.end_time
          end

          it 'expects new object to have same shipping_method' do
            delivery_slot.save!
            expect(subject.shipping_method).to eq delivery_slot.shipping_method
          end

          it 'expects new object to have different id' do
            delivery_slot.save!
            expect(subject.id).to_not eq delivery_slot.id
          end
        end

        context 'end time changed' do
          let(:new_end_time) { delivery_slot.end_time - 1.minute }

          before do
            delivery_slot.end_time = new_end_time
          end

          subject { Spree::DeliverySlot.last }

          it 'expects to create new delivery slot' do
            expect { delivery_slot.save! }
              .to change { Spree::DeliverySlot.unscoped.count }.by(1)
          end

          it 'expects new object to have changed end_time' do
            delivery_slot.save!
            expect(subject.end_time).to eq new_end_time
          end

          it 'expects new object to have same start_time' do
            delivery_slot.save!
            expect(subject.start_time).to eq delivery_slot.start_time
          end

          it 'expects new object to have same shipping_method' do
            delivery_slot.save!
            expect(subject.shipping_method).to eq delivery_slot.shipping_method
          end

          it 'expects new object to have different id' do
            delivery_slot.save!
            expect(subject.id).to_not eq delivery_slot.id
          end
        end

        context 'any other field changed' do
          before do
            delivery_slot.shipping_method = create(:shipping_method)
          end

          it 'expects to create new delivery slot' do
            expect { delivery_slot.save! }
              .to_not change { Spree::DeliverySlot.unscoped.count }
          end
        end
      end

      describe '#reload_and_set_deleted_at' do
        context 'start time changed' do
          let(:new_start_time) { delivery_slot.start_time + 1.minute }

          before do
            delivery_slot.start_time = new_start_time
          end

          it 'expects to set deleted at' do
            expect { delivery_slot.save! }
              .to change { delivery_slot.deleted_at }.from(nil)
          end

          it 'expects to not set start time' do
            expect { delivery_slot.save! }
              .to_not change { delivery_slot.reload.start_time }
          end
        end

        context 'end time changed' do
          let(:new_end_time) { delivery_slot.end_time - 1.minute }

          before do
            delivery_slot.end_time = new_end_time
          end

          it 'expects to set deleted at' do
            expect { delivery_slot.save! }
              .to change { delivery_slot.deleted_at }.from(nil)
          end

          it 'expects to not set end time' do
            expect { delivery_slot.save! }
              .to_not change { delivery_slot.reload.end_time }
          end
        end

        context 'any other field changed' do
          let(:new_shipping_method) { create(:shipping_method) }
          let(:old_shipping_method) { delivery_slot.shipping_method }

          def update_shipping_method(delivery_slot, new_shipping_method)
            delivery_slot.shipping_method = new_shipping_method
            delivery_slot.save!
          end

          it 'expects to not set deleted at' do
            expect { delivery_slot.save! }
              .to_not change { delivery_slot.deleted_at }
          end

          it 'expects to change shipping method' do
            expect { update_shipping_method(delivery_slot, new_shipping_method) }
              .to change { delivery_slot.reload.shipping_method }.from(old_shipping_method)
          end
        end
      end

      describe '#time_frame_changed?' do
        context 'start time changed' do
          let(:new_start_time) { delivery_slot.start_time + 1.minute }

          before do
            delivery_slot.start_time = new_start_time
          end

          subject { delivery_slot.send(:time_frame_changed?) }

          it { is_expected.to be true }
        end

        context 'end time changed' do
          let(:new_end_time) { delivery_slot.end_time - 1.minute }

          before do
            delivery_slot.end_time = new_end_time
          end

          subject { delivery_slot.send(:time_frame_changed?) }

          it { is_expected.to be true }
        end

        context 'any other field changed' do
          let(:new_shipping_method) { create(:shipping_method) }

          before do
            delivery_slot.shipping_method = new_shipping_method
            delivery_slot.save!
          end

          subject { delivery_slot.send(:time_frame_changed?) }

          it { is_expected.to be false }
        end
      end
    end
  end
end
