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
  # creator connection
  belongs_to :creator, class_name: "User"
  # event / attendees connection. The first line links to the join table and tells rails
  # to put this event's id in the attending_event_id column.
  # The second line links further on, to the user table, and tells rails to
  # use the event_attendee_id column to find the users attending.
  # Link 1: 'event' --> 'event_attendees'[attending_event_id] then
  # Link 2: 'event_attendees'[event_attendee_id] --> 'users'[id]
  # To access, e.g. @event.attendees
  has_many :event_attendees, foreign_key: :attending_event_id
  has_many :attendees, through: :event_attendees, source: :user
end

# app/models/user.rb
class User < ActiveRecord::Base
  # host connection
  has_many :created_events, foreign_key: :creator_id, class_name: "Event"
  # event / attendees connection
  has_many :event_attendees, foreign_key: :event_attendee_id
  has_many :attending_events, through: :event_attendees, source: :event
end

# app/models/event_attendee.rb
class EventAttendee < ActiveRecord::Base
  # event / attendees join table
  # Here we need to specify to rails exactly which foreign key in this table
  # leads to which other table (as their names are not inferable).
  belongs_to :event, foreign_key: :attending_event_id
  belongs_to :user, foreign_key: :event_attendee_id
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
  - EventsController - add #new and #create. #create uses #build to create with user ID prepopulated.
  - Create form for creating an event (event#create)
  - Create a view event#show - display details of event.

- Event attendance
  - Add association between User and Event - attendee and attended_event.
  - Create tables and foreign keys, including the through table
  - Create controller/routes for "through" table allowing a user to become an attendee of an event.
  - Create interface in view where user can indicate attending event.
  - Event's Show page displays list of attendees
  - User's Show page displays list of attended_events
  - Separate the user Show page into past and future events (using logic in the view only - only one query)

- Finishing touches
  - separate past and upcoming events on event#index - class methods on Event model (Event.past, Event.upcoming)
  - Refactor those methods into scopes
  - Add navigation (I might do this earlier)

- (My own fixes prior to doing extra)
  - Add appropriate validation
    - Sign in
      - User signed in to create events, view user page, or register to attend events.
    - Event Creation
      - Must have a title, description, location, date, start, finish
      - Date is in the future or today
    - Event Registration
      - User must not already be registered for that event.
      - Event must be today or in the future (do in view as well)
      - Note: Users can register to attend their own events
  - Add name to user model
    - Name shown on 'Your Events' page.
    - Name shown on Events Index and Show instead of creator email
    - Name shown as list of people attending event instead of email.
  - Refactor into partials
  - Bootstrap all of the accessible pages

- Extra
  - Allow users to edit and delete events they created
    - Add routes and controller actions
    - Add buttons to main Event Show view
    - Add edit view (link to from Event Show)

  - **Allow users to remove themselves as an attendee**
  - Make event private and add ability for event creator to invite specific users to an event.

### Notes

Test user details:
<test@test.com>
testing

<test2@test.com>
testing

<%= link_to "Delete", @friend, data: { turbo_method: :delete }, class: "btn btn-danger" %>
