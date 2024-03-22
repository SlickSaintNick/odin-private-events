class EventAttendeesController < ApplicationController
  def new
    @event_attendee = EventAttendee.new
  end

  def create
    @event = Event.find(params[:event_id])
    @event_attendee = @event.event_attendees.create(event_attendee_id: current_user.id)
    if @event_attendee.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def event_attendee_params
    params.require(:event_attendee).permit(:event_attendee_id, :attending_event_id)
  end
end
