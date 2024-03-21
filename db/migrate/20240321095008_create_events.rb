class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :location
      t.date :date
      t.time :start_time
      t.time :finish_time
      t.timestamps
    end
  end
end
