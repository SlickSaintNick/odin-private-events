class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @created_events = current_user.created_events.all.order(created_at: 'DESC')
    @attending_events = current_user.attending_events.order(date: 'ASC')
  end
end
