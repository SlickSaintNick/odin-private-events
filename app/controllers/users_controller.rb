class UsersController < ApplicationController
  def show
    @events = current_user.created_events.all.order(created_at: 'DESC')
  end
end
