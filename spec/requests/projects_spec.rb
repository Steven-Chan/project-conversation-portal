require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /projects" do
    it "show project list page successfully" do
      get '/projects'
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "show project list page successfully after login" do
      sign_in_as(user)
      get '/projects'
      expect(response.status).to eq(200)
    end
  end
end
