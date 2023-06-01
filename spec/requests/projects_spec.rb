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

  describe "GET /projects/new" do
    it "cannot show create project page if not logged in" do
      get "/projects/new"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "show create project page" do
      sign_in_as(user)
      get "/projects/new"
      expect(response.status).to eq(200)
    end
  end

  describe "POST /projects" do
    it "cannot create project if not looged in" do
      post "/projects"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "create project successfully" do
      sign_in_as(user)
      expect do
        post "/projects", params: {
          project: {
            name: "Project A",
            description: "ABC",
            status: :pending
          }
        }
      end.to change { Project.count }.by(1)
      project = Project.order(created_at: :desc).first
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq("http://www.example.com/projects/#{project.id}")
    end

    it "cannot create project with empty name" do
      sign_in_as(user)
      expect do
        post "/projects", params: {
          project: {
            name: "",
            description: "ABC",
            status: :pending
          }
        }
      end.to change { Project.count }.by(0)
      expect(response.status).to eq(422)
    end
  end

  describe "GET /projects/{id}" do
    let!(:project) { FactoryBot.create(:project) }

    it "cannot show project page if not logged in" do
      get "/projects/#{project.id}"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "show create project page" do
      sign_in_as(user)
      get "/projects/#{project.id}"
      expect(response.status).to eq(200)
    end

    it "redirect to project list page for invalid project id" do
      sign_in_as(user)
      get "/projects/whatever"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/projects')
    end
  end
end
