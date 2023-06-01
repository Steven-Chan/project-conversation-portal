# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: %i[show edit update]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    ActiveRecord::Base.transaction do
      @project = Project.new(project_params)
      @project.created_by = current_user
      @project.updated_by = current_user
      @project.save!

      create_project_event!(ProjectCreatedEvent)

      redirect_to project_path(@project.id), notice: 'Project has been created.'
    rescue StandardError
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @project.assign_attributes(project_params)
      @project.updated_by = current_user
      @project.save!

      create_project_event!(ProjectUpdatedEvent) if @project.previous_changes.present?
      create_project_event!(ProjectStatusChangedEvent) if @project.previous_changes.key?(:status)

      redirect_to project_path(@project.id), notice: 'Project has been updated.'
    end
  rescue StandardError
    render :new, status: :unprocessable_entity
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: 'Project not found.'
  end

  def create_project_event!(klass)
    activity = klass.new
    activity.project = @project
    activity.created_by = current_user
    activity.save!
  end
end
