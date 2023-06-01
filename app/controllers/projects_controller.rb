class ProjectsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: [:show, :edit]

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
        redirect_to project_path(@project.id), notice: "Project has been created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show; end

  def edit; end

  private

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end
end
