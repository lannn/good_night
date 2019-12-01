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
        expect(sleep_clock.errors.full_messages).to include("Wakeup can't be less than bedtime")
      end
    end
  end
end
