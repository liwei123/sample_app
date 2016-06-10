require 'rails_helper'

describe Micropost do

  context 'validations' do
    let!(:user1) { FactoryGirl.create(:user, name: "Foo", email: "foo@gmail.com", password: "123456", password_confirmation: "123456") }
    subject { Micropost.new }

    context 'passed' do
      it "checks micropost is valid" do
        subject.update(content: "Lorem ipsum", user_id: user1.id)
        expect(subject).to be_valid
      end

      it "checks order by most recent first" do
        subject.update(content: "Checks that this is the most recent post", user_id: user1.id, created_at: Time.zone.now)
        subject.save
        expect(subject).to eql(Micropost.first)
      end
    end

    context 'failed' do
      it "checks user id is present" do
        subject.update(content: "Lorem ipsum", user_id: nil)
        expect(subject).to_not be_valid
      end

      it "checks content present" do
        subject.update(content: "    ", user_id: user1.id)
        expect(subject).to_not be_valid
      end

      it "checks content at most 140 chars" do
        subject.update(content: "a" * 141, user_id: user1.id)
        expect(subject).to_not be_valid
      end
    end
  end
end