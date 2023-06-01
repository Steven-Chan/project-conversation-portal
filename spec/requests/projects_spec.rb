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

    describe "create project successfully" do
      before { sign_in_as(user) }
      let(:action) do
        post "/projects", params: {
          project: {
            name: "Project A",
            description: "ABC",
            status: :pending
          }
        }
      end

      it "add project count" do
        expect { action }.to change { Project.count }.by(1)
      end

      it "add new project activity" do
        expect { action }.to change { ProjectActivity.count }.by(1)
        activity = ProjectActivity.order(created_at: :desc).first
        expect(activity).to be_a(ProjectCreatedEvent)

        project = Project.order(created_at: :desc).first
        expect(activity.project.id).to eq(project.id)
      end

      it "redirect to project page" do
        action
        project = Project.order(created_at: :desc).first
        expect(response.status).to eq(302)
        expect(response.header.fetch('Location')).to eq("http://www.example.com/projects/#{project.id}")
      end

      it "has correct create and update user" do
        action
        project = Project.order(created_at: :desc).first
        expect(project.created_by_id).to eq(user.id)
        expect(project.updated_by_id).to eq(user.id)
      end
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
    let!(:project) { FactoryBot.create(:project, created_by: user, updated_by: user) }

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

  describe "GET /projects/{id}/edit" do
    let!(:project) { FactoryBot.create(:project, created_by: user, updated_by: user) }

    it "cannot show edit project page if not logged in" do
      get "/projects/#{project.id}/edit"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    it "show edit project page" do
      sign_in_as(user)
      get "/projects/#{project.id}/edit"
      expect(response.status).to eq(200)
    end

    it "redirect to project list page for invalid project id" do
      sign_in_as(user)
      get "/projects/whatever/edit"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/projects')
    end
  end

  describe "PUT /projects/{id}" do
    let!(:project) { FactoryBot.create(:project, created_by: user, updated_by: user) }

    it "cannot update project if not looged in" do
      put "/projects/#{project.id}"
      expect(response.status).to eq(302)
      expect(response.header.fetch('Location')).to eq('http://www.example.com/users/sign_in')
    end

    describe "update project successfully" do
      before { sign_in_as(user) }
      let(:action) do
        put "/projects/#{project.id}", params: {
          project: {
            name: "Project A",
            description: "ABC",
            status: :pending
          }
        }
      end

      it "does not add new project" do
        expect { action }.to change { Project.count }.by(0)
      end

      it "add new project activity" do
        expect { action }.to change { ProjectActivity.count }.by(1)
        activity = ProjectActivity.order(created_at: :desc).first
        expect(activity).to be_a(ProjectUpdatedEvent)
        expect(activity.project_id).to eq(project.id)
      end

      it "redirect to project detail page" do
        action
        project.reload
        expect(response.status).to eq(302)
        expect(response.header.fetch('Location')).to eq("http://www.example.com/projects/#{project.id}")
      end

      it "update the attributes correctly" do
        action
        project.reload
        expect(project.name).to eq("Project A")
        expect(project.description).to eq("ABC")
        expect(project.status).to eq("pending")
        expect(project.created_by_id).to eq(user.id)
        expect(project.updated_by_id).to eq(user.id)
      end
    end

    describe "update project status" do
      before { sign_in_as(user) }
      let(:action) do
        put "/projects/#{project.id}", params: {
          project: {
            name: "Project A",
            description: "ABC",
            status: :wip
          }
        }
      end

      it "adds two activities" do
        expect { action }.to change { ProjectActivity.count }.by(2)
      end

      it "add one update event" do
        expect { action }.to change { ProjectUpdatedEvent.count }.by(1)
      end

      it "add one status change event" do
        expect { action }.to change { ProjectStatusChangedEvent.count }.by(1)
      end
    end

    it "update project by another user" do
      another_user = FactoryBot.create(:user)
      sign_in_as(another_user)
      put "/projects/#{project.id}", params: {
        project: {
          name: "Project A",
          description: "ABC",
          status: :wip
        }
      }
      expect(response.status).to eq(302)
      project = Project.order(created_at: :desc).first
      expect(project.created_by_id).to eq(user.id)
      expect(project.updated_by_id).to eq(another_user.id)
    end

    it "cannot update project with empty name" do
      sign_in_as(user)
      expect do
        put "/projects/#{project.id}", params: {
          project: {
            name: "",
            description: "ABC",
            status: :pending
          }
        }
      end.to change { Project.count }.by(0)
      expect(response.status).to eq(422)
      project = Project.order(created_at: :desc).first
      expect(project.name).to eq("Example")
    end
  end
end
