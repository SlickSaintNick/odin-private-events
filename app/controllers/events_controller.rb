class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    # @events = Event.all
    @past_events = Event.all.past
    @future_events = Event.all.future
  end

  def show
    # Add current_user_attending? variable
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :date, :start_time, :finish_time, :creator_id)
  end
end
