class Event < ApplicationRecord
  belongs_to :creator, class_name: "User"
  # Has-many attendees :through event_attendees table
  has_many :event_attendees, foreign_key: :attending_event_id
  has_many :attendees, through: :event_attendees, source: :event_attendee
end
