class EventAttendeesController < ApplicationController
  before_action :authenticate_user!

  def new
    @event_attendee = EventAttendee.new
  end

  def create
    @event = Event.find(params[:event_id])

    if @event.attendee_ids.include?(current_user.id) || @event.date < Date.today
      render "events/show", status: :unprocessable_entity
    else
      @event_attendee = @event.event_attendees.create(event_attendee_id: current_user.id)
      if @event_attendee.save
        redirect_back_or_to root_path
      else
        render "events/show", status: :unprocessable_entity
      end
    end
  end

  def destroy
    EventAttendee.where(event_attendee_id: current_user.id, attending_event_id: params[:event_id]).destroy_all
    redirect_back_or_to root_path
  end

  private

    def event_attendee_params
      params.require(:event_attendee).permit(:event_attendee_id, :attending_event_id)
    end
end
