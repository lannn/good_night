require 'rails_helper'

RSpec.describe SleepClock, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:bedtime) }

  describe "#wakeup_greater_than_bedtime" do
    context "when the wakeup time is greater than bedtime" do
      let(:sleep_clock) { build(:sleep_clock) }
      it "returns no error" do
        sleep_clock.valid?
        expect(sleep_clock.errors).to be_empty
      end
    end

    context "when the wakeup time is less than bedtime" do
      let(:sleep_clock) { build(:sleep_clock, bedtime: DateTime.current, wakeup: 2.hours.ago) }
      it "returns errors" do
        sleep_clock.valid?
        expect(sleep_clock.errors.full_messages).to include("Wakeup must greater than bedtime")
      end
    end
  end

  describe ".in_past_week" do
    let!(:beginning_of_past_week) { 1.week.ago.beginning_of_week }
    let!(:end_of_past_week) { 1.week.ago.end_of_week }
    let!(:invalid_sleep_clock_1) { create(:sleep_clock, bedtime: beginning_of_past_week - 1.hours, wakeup: beginning_of_past_week + 7.hours) }
    let!(:sleep_clock_1) { create(:sleep_clock, bedtime: beginning_of_past_week + 23.hours, wakeup: beginning_of_past_week + 31.hours) }
    let!(:sleep_clock_2) { create(:sleep_clock, bedtime: beginning_of_past_week + 1.day + 23.hours, wakeup: beginning_of_past_week + 1.day + 32.hours) }
    let!(:sleep_clock_3) { create(:sleep_clock, bedtime: end_of_past_week - 1.hours, wakeup: end_of_past_week + 7.hours) }

    it "returns the sleep clocks in the past week" do
      sleep_clock_ids = SleepClock.in_past_week.pluck(:id)
      expect(sleep_clock_ids.size).to eq(3)
      expect(sleep_clock_ids).to include(sleep_clock_1.id, sleep_clock_2.id, sleep_clock_3.id)
    end
  end

  describe ".ordered_by_sleep_length_desc" do
    let!(:beginning_of_past_week) { 1.week.ago.beginning_of_week }
    let!(:end_of_past_week) { 1.week.ago.end_of_week }
    let!(:sleep_clock_1) { create(:sleep_clock, bedtime: beginning_of_past_week + 23.hours, wakeup: beginning_of_past_week + 31.hours) }
    let!(:sleep_clock_2) { create(:sleep_clock, bedtime: beginning_of_past_week + 1.day + 23.hours, wakeup: beginning_of_past_week + 1.day + 32.hours) }

    it "returns the sleep clocks ordered by sleep length desc" do
      sleep_clock_ids = SleepClock.ordered_by_sleep_length_desc.pluck(:id)
      expect(sleep_clock_ids.first).to eq(sleep_clock_2.id)
      expect(sleep_clock_ids.last).to eq(sleep_clock_1.id)
    end
  end
end
