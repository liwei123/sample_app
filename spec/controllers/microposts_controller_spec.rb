require 'rails_helper'

describe Micropost do

  context "redirect" do
    let!(:michael) { FactoryGirl.create(name: "Michael", email: "michael@example.com", password_digest: User.digest('password'),
                                        admin: true, activated:true, activated_at: Time.zone.now) }
    let(:orange) { create :micropost, content: "I just ate an orange!", created_at: 10.minutes.ago, user: :michael}

    it "checks redirect create when not logged in" do
      current_count = Micropost.count
      orange.save
      expect(current_count+1).to eql(Micropost.count)
    end

  end
end