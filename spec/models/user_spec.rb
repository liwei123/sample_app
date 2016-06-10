require 'rails_helper'


# fixtures :all

describe User do
  subject { User.new }

  context 'validations' do
    context 'passed' do

      it "checks user is valid" do
        subject.update(name: "Example User", email: "user@example.com",
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to be_valid
      end
    end

    context 'failed' do
      it "raise exception if name is blank" do
        subject.update(email: "user@example.com",
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to_not be_valid
      end


      it "checks email is present" do
        subject.update(name: "Example User",
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to_not be_valid
      end

      it "checks name is not too long" do
        subject.update(name: "a" * 141, email: "user@example.com",
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to_not be_valid
      end

      it "checks email is not too long" do
        subject.update(name: "Example User", email: "a" * 244 + "@example.com",
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to_not be_valid
      end
    end
  end

  context 'email validations' do
    let!(:user1) { FactoryGirl.create(:user, name: "Foo", email: "foo@gmail.com") }
    let(:user2) { FactoryGirl.create(:user, name: "Bar", email: "foo@gmail.com") }

    it "checks email validation accepts valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        subject.update(name: "Example User", email: valid_address,
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to be_valid
      end
    end

    it "checks email validation rejects invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        subject.update(name: "Example User", email: invalid_address,
                              password: "foobar", password_confirmation: "foobar")
        expect(subject).to_not be_valid
      end
    end

    it "checks email addresses should be unique" do
      expect { user2 }.to raise_error
    end
  end

  context "password validations" do
    it "checks password should be non blank" do
      subject.update(name: "Example User", email: "user@example.com",
                            password: "    ", password_confirmation: "    ")
      expect(subject).to_not be_valid
    end

    it "checks password have a minimum length" do
      subject.update(name: "Example User", email: "user@example.com",
                            password: "aaaaa", password_confirmation: "aaaaa")
      expect(subject).to_not be_valid
    end
  end

  context "authentication" do
    it "checks authenticated? return false for a user with nil digest" do
      subject.update(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar")
      expect(subject.authenticated?(:remember, '')).to be false
    end
  end

  context "microposts" do
    let!(:user1) { FactoryGirl.create(:user, name: "Foo", email: "foo1@gmail.com", password: "123456", password_confirmation: "123456") }
    let(:user2) { FactoryGirl.create(:user, name: "Bar", email: "foo2@gmail.com", password: "123456", password_confirmation: "123456") }
    let(:user3) { FactoryGirl.create(:user, name: "FooBar", email: "foo3@gmail.com", password: "123456", password_confirmation: "123456") }

    it "checks associated microposts should be destroyed" do
      subject.update(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar")
      subject.microposts.create!(content: "Lorem ipsum")
      current_count = subject.microposts.count
      subject.destroy
      expect(subject.microposts.count).to be_eql(current_count-1)
    end

    it "checks follows and unfollow user" do
      user1.follow(user2)
      expect(user1.following?(user2)).to be true
      user1.unfollow(user2)
      expect(user1.following?(user2)).to be false
    end

    it "checks feed have the right posts" do
      user1.follow(user2)
      user2.microposts.each do |post_following|
        expect(user1.feed.include?(post_following)).to be true
      end
      user1.microposts.each do |self_post|
        expect(user1.feed.include?(self_post)).to be true
      end
      user3.microposts.each do |post_unfollowed|
        expect(user1.feed.include?(post_unfollowed)).to be false
      end
    end

  end


end