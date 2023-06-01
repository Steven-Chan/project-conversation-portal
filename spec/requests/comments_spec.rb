require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "POST /projects/{project_id}/comments" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:project) { FactoryBot.create(:project) }

    it "cannot create comment if not looged in" do
      post "/projects/#{project.id}/comments"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "redirect to project list page if project not found" do
      sign_in_as(user)
      post "/projects/whatever/comments", params: {
        # TODO
      }
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq("http://www.example.com/projects")
    end

    it "create comment successfully" do
      sign_in_as(user)
      post "/projects/#{project.id}/comments", params: {
        # TODO
      }
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq("http://www.example.com/projects/#{project.id}")
    end
  end
end
