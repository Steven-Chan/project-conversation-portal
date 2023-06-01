class CommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: [:create]

  def create
    @comment = Comment.new(comment_params)
    @comment.created_by = current_user
    @comment.updated_by = current_user
    @comment.project = @project
    @comment.save.tap do |successful|
      if successful
        redirect_to project_path(@project)
      else
        head :unprocessable_entity
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end
end
