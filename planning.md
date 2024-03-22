# Planning

Two tables with two relationships.

- A user can attend events: User has_and_belongs_to_many Event
- A user can create an event: creator(User) has_many events. Event belongs_to one creator

## Model

An Event can have multiple attendees (who are Users). Linking table called `event_attendees`.

- `attending_event_id` - contains Event IDs indicating which event
- `event_attendee_id` - contains User IDs indicating which attendee
- Events can be attended by more than one attendee. Attendees can attend more than one event.
- Each Event also has a single Creator, who is also a User.
- Creators can attend their own Events.

```rb
# app/models/event.rb
class Event < ActiveRecord::Base
  # event / attendees connection
  has_many :event_attendees, foreign_key: :attending_event_id
  has_many :attendees, through: :event_attendees, source: :event_attendee
  # creator connection
  belongs_to :creator, class_name: "User"
end

# app/models/user.rb
class User < ActiveRecord::Base
  # event / attendees connection
  has_many :event_attendees, foreign_key: :event_attendee_id
  has_many :attendees, through: :event_attendees
  # host connection
  has_many :created_events, foreign_key: :creator_id, class_name: "Event"
end

# app/models/event_attendees.rb
class EventAttendee < ActiveRecord::Base
  # event / attendees join table
  belongs_to :event_attendee, class_name: "User"
  belongs_to :attending_event, class_name: "Event"
end
```

## Migration

```rb
class CreateEvents
  def change
    create_table :events do |t|
      t.belongs_to :creator, class_name: "User", index: true, foreign_key: true
      t.string :title
      t.string :description
      t.string :location
      t.date :date
      t.time :start_time
      t.time :finish_time
      t.timestamps
    end

    create_table :attendees_events do |t|
      t.references :event_attendee, foreign_key: { to_table: :users }
      t.references :attending_event, foreign_key: { to_table: :events }
      t.timestamps
    end
  
    # Devise to add users with email and password - add "name" field using usual method
  end
end
```

## Specs

- User can create events
- User can attend many events
- Event can be attended by many users
- Events take place at a specific date and location (string)

### Key steps

- Events and users
  - Generate and migrate Event model (no foreign keys or validations)
  - Generate EventsController
  - Add #index action to display all events
  - Create #index view with heading and table
  - Add devise, create User model
  - Set root_path to events#index
  - Add association between User and event - creator, and foreign key to Event model. Specify :foreign_key, :class_name.
  - Create a view user#show - lists all events a user has created.
  - * EventsController - add #new and #create. #create uses #build to create with user ID prepopulated.
  - Create form for creating an event (event#create)
  - Create a view event#show - display details of event.

- Event attendance
  - Add association between User and Event - attendee and attended_event.
  - Create tables and foreign keys, including the through table
  - Create controller/routes for "through" table allowing a user to become an attendee of an event. Create interface in view where user can indicate attending event.
  - Event's Show page displays list of attendees
  - User's Show page displays list of attended_events
  - Separate the user Show page into past and future events

- Finishing touches
  - separate past and upcoming events on event#index - class methods on Event model (Event.past, Event.upcoming)
  - Refactor those methods into scopes
  - Add navigation (I might do this earlier)

- Extra
  - Allow users to edit and delete events they created
  - Allow users to remove themselves as an attendee
  - Make event private and add ability for event creator to invite specific users to an event.

### Notes

Test user details:
<test@test.com>
testing

<test2@test.com>
testing
