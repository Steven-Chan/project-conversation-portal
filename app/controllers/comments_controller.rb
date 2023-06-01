class CommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: [:create]

  def create
    # TODO
    redirect_to project_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end
end
