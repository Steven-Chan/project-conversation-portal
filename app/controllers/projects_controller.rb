class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.save.tap do |successful|
      if successful
        # navigate to project show page
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end
end
