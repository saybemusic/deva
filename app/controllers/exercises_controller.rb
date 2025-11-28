class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end

  def show
    @exercise = Exercise.find(params[:id])
    @chat = @exercise.chats.find_by(user: current_user, context: "exo")
    @message = Message.new
  end

end
