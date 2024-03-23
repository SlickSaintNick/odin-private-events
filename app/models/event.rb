class Event < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000}
  validates :location, presence: true, length: { maximum: 200 }
  validates :date, presence: true, comparison: { greater_than_or_equal_to: Date.today }
  # Users may omit start_time / finish_time and may have events start after they finish
  # (to handle case where event begins at 11pm and finishes at 1am)

  belongs_to :creator, class_name: "User"
  # Has-many attendees :through event_attendees table
  has_many :event_attendees, foreign_key: :attending_event_id
  has_many :attendees, through: :event_attendees, source: :user

  # Using Scopes
  scope :past, -> { where('date < ?', Date.today) }
  scope :future, -> { where('date >= ?', Date.today) }

  # Using Class methods
  # def self.past
  #   where('date < ?', Date.today)
  # end

  # def self.future
  #   where('date >= ?', Date.today)
  # end
end
