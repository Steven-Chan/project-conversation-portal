class AddCreatedByAndUpdatedBy < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :created_by, foreign_key: { to_table: :users }
    add_reference :projects, :updated_by, foreign_key: { to_table: :users }

    add_reference :comments, :created_by, foreign_key: { to_table: :users }
    add_reference :comments, :updated_by, foreign_key: { to_table: :users }
  end
end
