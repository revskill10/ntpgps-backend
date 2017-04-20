class CheckInsController < ApplicationController
  def index
  	render json: current_user.check_ins
  end

  def create
  	command = CreateCheckIn.call(current_user, params[:latitude], params[:longitude])
    if command.success? 
      render json: { check_in: command.result } 
    else 
      render json: { error: command.errors }, status: :unauthorized 
    end
  end
end