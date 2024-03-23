class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :created_events, foreign_key: :creator_id, class_name: "Event"

  # Has_many :attending_events through event_attendees table
  has_many :event_attendees, foreign_key: :event_attendee_id
  has_many :attending_events, through: :event_attendees, source: :event
end
