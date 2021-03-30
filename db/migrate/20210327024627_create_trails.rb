class CreateTrails < ActiveRecord::Migration[6.1]
  def change
    create_table :trails do |t|
      t.string :name
      t.float :distance
      t.string :surface
      t.string :info
      t.integer :user_id
      t.integer :state_id
    end
  end
end
