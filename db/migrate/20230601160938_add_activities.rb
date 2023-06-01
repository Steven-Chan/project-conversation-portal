# frozen_string_literal: true

class AddActivities < ActiveRecord::Migration[7.0]
  def change
    rename_table :comments, :project_activities

    # add inheritance to the table
    add_column :project_activities, :type, :string
    execute "UPDATE project_activities SET type = 'Comment'"
    change_column_null :project_activities, :type, false
  end
end
