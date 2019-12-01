class SleepClocksController < ApplicationController
  before_action :set_sleep_clock, only: [:show, :update, :destroy]

  def index
    @sleep_clocks = current_user.sleep_clocks.order(created_at: :desc)
  end

  def friends
    @sleep_clocks = SleepClock.where(user: current_user.followers).in_past_week.ordered_by_sleep_length_desc
  end

  def show
  end

  def create
    @sleep_clock = current_user.sleep_clocks.new(sleep_clock_params)

    if @sleep_clock.save
      render :show, status: :created
    else
      render json: { errors: @sleep_clock.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @sleep_clock.update(sleep_clock_params)
      render :show
    else
      render json: { errors: @sleep_clock.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @sleep_clock.destroy
    head :no_content
  end

  private

  def set_sleep_clock
    @sleep_clock = SleepClock.find(params[:id])
  end

  def sleep_clock_params
    params.permit(:bedtime, :wakeup)
  end
end
