require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "POST /projects/{project_id}/comments" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:project) { FactoryBot.create(:project, created_by: user, updated_by: user) }

    it "cannot create comment if not looged in" do
      post "/projects/#{project.id}/comments"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "redirect to project list page if project not found" do
      sign_in_as(user)
      expect do
        post "/projects/whatever/comments", params: {
          comment: {
            content: "Hello"
          }
        }
      end.to change { Comment.count }.by(0)
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq("http://www.example.com/projects")
    end

    describe "create comment successfully" do
      before { sign_in_as(user) }
      let(:action) do
        post "/projects/#{project.id}/comments", params: {
          comment: {
            content: "Hello"
          }
        }
      end

      it "redirect to project page" do
        action
        expect(response.status).to eq(302)
        expect(response.header.fetch('Location')).to eq("http://www.example.com/projects/#{project.id}")
      end

      it "create a new comment" do
        expect { action }.to change { Comment.count }.by(1)
      end

      it "add a new comment to the project" do
        expect { action }.to change { project.comments.count }.by(1)
      end
    end

    describe "cannot create comment with empty content" do
      before { sign_in_as(user) }
      let(:action) do
        post "/projects/#{project.id}/comments", params: {
          comment: {
            content: ""
          }
        }
      end

      it "redirect to project page" do
        action
        expect(response.status).to eq(422)
      end

      it "comment count not changed" do
        expect { action }.to change { Comment.count }.by(0)
      end
    end
  end
end
