class AddCreatorIdToEvents < ActiveRecord::Migration[7.1]
  def change
    add_reference :events, :creator_id, foreign_key: true
    add_index :events, :creator_id
  end
end
