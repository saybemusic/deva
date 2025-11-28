class ExercisesController < ApplicationController

  def index
    @exercises = Exercise.all
  end

  def show
    @exercise = Exercise.find(params[:id])
    # Soit on crée un chat, soit on récupère celui qui existe déjà pour cet exo
    @chat = Chat.new
    @chat.user = current_user
    @chat.context = "exo"
    @chat.save
    @message = Message.new

  end

end
