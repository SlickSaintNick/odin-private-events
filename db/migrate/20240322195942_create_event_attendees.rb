class CreateEventAttendees < ActiveRecord::Migration[7.1]
  def change
    create_table :event_attendees do |t|
      t.references :event_attendee, foreign_key: { to_table: :users }
      t.references :attending_event, foreign_key: { to_table: :events }
      t.timestamps
    end
  end
end
