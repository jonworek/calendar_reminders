require 'spec_helper'

describe Appointment do

  context "when a user has already created appointments" do
    let!(:user) { User.create(email: 'foo@foo.com', name: 'foo') }
    let!(:apt_1) { Appointment.create(user_id: 1, start: 1.month.from_now) }
    let!(:apt_2) { Appointment.create(user_id: 1, start: 2.month.from_now) }

    before(:each) do
      apt_2.reminder_history_entries.create
      user.set_default_user_settings
    end

    it "should return a list of appointments for a given user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(2)
    end

    it "should return the unreminded appointments" do
      Appointment.create(user_id: 1, start: 10.minutes.from_now)
      appointments = Appointment.unreminded_upcoming
      expect(appointments.count).to eq(1)
    end
  end

  context "when a user does not have any appointments created" do

    it "should not return any appointments for this user" do
      appointments = Appointment.where(user_id: 1)
      expect(appointments.count).to eq(0)
    end
 
  end
end
