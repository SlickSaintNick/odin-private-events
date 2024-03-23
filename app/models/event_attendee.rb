class EventAttendee < ApplicationRecord
  belongs_to :event, foreign_key: :attending_event_id
  belongs_to :user, foreign_key: :event_attendee_id
end
