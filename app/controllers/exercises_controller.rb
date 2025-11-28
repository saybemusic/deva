class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end

  def show
    @exercise = Exercise.find(params[:id])
    @chat = @exercise.chats.find_by(user: current_user, context: "exo")
    @message = Message.new
  end

  def finish
    @exercise = Exercise.find(params[:id])
    @exercise.update(finished: true)  # met à jour l'exercice et déclenche after_save pour le pourcentage

    # Reste sur la page précédente (vue programme) après le clic
    redirect_back fallback_location: program_path(@exercise.program), notice: "Exercice marqué comme terminé !"
  end
end
