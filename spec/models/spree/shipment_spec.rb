require 'spec_helper'

module Spree
  describe Shipment do
    let(:delivery_slot_enabled_shipping_method) { create(:shipping_method, is_delivery_slots_enabled: true) }
    let(:delivery_slot_disabled_shipping_method) { create(:shipping_method, is_delivery_slots_enabled: false) }

    describe 'Associations' do
      it { is_expected.to belong_to(:delivery_slot) }
    end

    describe 'Delegate' do
      it { is_expected.to delegate_method(:is_delivery_slots_enabled?).to(:shipping_method) }
    end

    describe 'Validations' do
      describe '#verify_delivery_slot' do
        context 'when shipping method is delivery slots enabled' do
          let(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [delivery_slot_enabled_shipping_method]
            shipment.delivery_slot = delivery_slot
            shipment
          end

          context 'when delivery slot is present' do
            context 'when delivery slot\'s shipping_method is not same as shipment\'s shipping_method' do
              let(:delivery_slot_enabled_shipping_method2) { create(:shipping_method, is_delivery_slots_enabled: true) }
              let(:delivery_slot2) { delivery_slot_enabled_shipping_method2.delivery_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.delivery_slot = delivery_slot2
                shipment.valid?
              end

              it { expect(shipment).not_to be_valid }
              it { expect(shipment.errors[:delivery_slot_id]).to include(I18n.t(:should_belongs_to_correct_shipping_method, scope: [:activerecord, :errors, :models, 'spree/shipment'])) }
            end

            context 'when delivery slot\'s shipping_method is same as shipment\'s shipping_method' do
              let(:delivery_slot2) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.delivery_slot = delivery_slot2
              end

              it { expect(shipment).to be_valid }
            end
          end

          context 'when delivery slot is not present' do
            before do
              shipment.delivery_slot = nil
            end

            it { expect(shipment).to be_valid }
          end
        end

        context 'when shipping method is not delivery slots enabled' do
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [delivery_slot_disabled_shipping_method]
            shipment
          end

          context 'when delivery slot is present' do
            context 'when delivery slot\'s shipping_method is not same as shipment\'s shipping_method' do
              let(:delivery_slot_enabled_shipping_method2) { create(:shipping_method, is_delivery_slots_enabled: true) }
              let(:delivery_slot2) { delivery_slot_enabled_shipping_method2.delivery_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.delivery_slot = delivery_slot2
                shipment.valid?
              end

              it { expect(shipment).to be_valid }
            end

            context 'when delivery slot\'s shipping_method is same as shipment\'s shipping_method' do
              let(:delivery_slot2) { delivery_slot_disabled_shipping_method.delivery_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.delivery_slot = delivery_slot2
              end

              it { expect(shipment).to be_valid }
            end
          end

          context 'when delivery slot is not present' do
            before do
              shipment.delivery_slot = nil
            end

            it { expect(shipment).to be_valid }
          end
        end
      end
    end

    describe 'Callbacks' do
      describe '#ensure_valid_delivery_slot' do
        def update_shipping_methods(shipment, shipping_methods)
          shipment.shipping_methods = shipping_methods
          shipment.save
        end

        context 'when new shipping method is not delivery slot disabled' do
          let(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [delivery_slot_enabled_shipping_method]
            shipment.delivery_slot = delivery_slot
            shipment
          end

          it 'expects to nullify delivery_slot' do
            expect { update_shipping_methods(shipment, [delivery_slot_disabled_shipping_method]) }
              .to change { shipment.delivery_slot_id }.from(delivery_slot.id).to(nil)
          end
        end

        context 'when new shipping method is delivery slot disabled' do
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [delivery_slot_disabled_shipping_method]
            shipment
          end

          it 'expects to not nullify delivery_slot' do
            expect { update_shipping_methods(shipment, [delivery_slot_disabled_shipping_method]) }
              .to_not change { shipment.delivery_slot_id }
          end
        end
      end
    end

    describe '#delivery_slot_time_frame' do
      context 'when shipping method is delivery slot enabled' do
        context 'when delivery slot is present' do
          let!(:delivery_slot) { delivery_slot_enabled_shipping_method.delivery_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
          let!(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [delivery_slot_enabled_shipping_method]
            shipment.delivery_slot = delivery_slot
            shipment
          end

          it { expect(shipment.delivery_slot_time_frame).to eq delivery_slot.time_frame }
        end

        context 'when delivery slot is not present' do
          let!(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [delivery_slot_enabled_shipping_method]
            shipment
          end

          it { expect(shipment.delivery_slot_time_frame).to eq Spree.t(:any_time) }
        end
      end

      context 'when shipping method is not delivery slot enabled' do
        let!(:shipment) do
          shipment = create(:shipment)
          shipment.shipping_methods = [delivery_slot_disabled_shipping_method]
          shipment
        end

        it { expect(shipment.delivery_slot_time_frame).to eq Spree.t(:any_time) }
      end
    end
  end
end
