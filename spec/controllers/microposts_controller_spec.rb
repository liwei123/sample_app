require 'rails_helper'

describe MicropostsController, :type => :controller do
  subject { Micropost.new }

  context "redirect POST create" do
    let(:make_request) { post :create, params }
    let (:params) {{
        :orange => { content: "Lorem ipsum"
        }
    }}

    it "checks redirect create when not logged in" do
      expect{make_request}.to change{Micropost.count}.by(0)
      expect(response).to redirect_to(login_url)
    end
  end

  context "redirect POST destroy" do
    let(:make_request) { post :destroy, params }
    let(:micropost) { create :micropost}

    let (:params) { {
        :id => user.to_param,
    } }
    it "checks redirect destroy when not logged in" do

    end
  end
end