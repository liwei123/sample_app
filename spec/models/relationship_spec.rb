require 'rails_helper'


# fixtures :all

describe Relationship do
  subject { Relationship.new }

  context 'validations' do
    context 'passed' do
      it "checks relationship is valid" do
        subject.update(follower_id: 1, followed_id: 2)
        expect(subject).to be_valid
      end
    end

    context 'failed' do
      it "checks follower id not present" do
        subject.update(follower_id: nil)
        expect(subject).to_not be_valid
      end
    end
  end
end