require 'json'

class ProgramsController < ApplicationController

  CREATEJSON = "Tu es un senior dev en Ruby.

Ta réponse doit être UNIQUEMENT un objet JSON valide.
N’ajoute aucun texte avant ou après le JSON.
N’utilise pas de markdown, pas de commentaires, pas de trailing comma.
Toutes les clés doivent être des clés pour ruby et les valeur seront des string entre guillement double

Renvie exactement un objet JSON de ce type :

{
  exercices: [
    {
      title: 'string',
      enonce: 'string',
      correction: 'string'
    }
  ],
  conseil: 'string'
}"

  def index
    @programs = Program.all
  end

  def show
    @program = Program.find(params[:id])
  end

  def new
    @program = Program.new
  end

  def edit
    @program = Program.find(params[:id])
  end

  def update
    @program = Program.find(params[:id])
    if @program.update(program_params)
      redirect_to @program, notice: "Program was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy
    redirect_to programs_path, status: :see_other
  end

  def create

    @chat = current_user.chats.find(params[:format])

    user_messages = @chat.messages
    .where(role: "user")
    .order(:created_at)
    .limit(3)

    @ia_message = @chat.messages.where(role: "assistant").last

    @program = Program.new(
      title: @chat.title,
      difficulty: user_messages[1]&.content,
      language: user_messages[0]&.content,
      chat: @chat,
      user: current_user
      )

    if @program.save
      @ruby_llm_chat = RubyLLM.chat
      listExo = @ruby_llm_chat.with_instructions(CREATEJSON).ask(@ia_message.content)
      data = JSON.parse(listExo.content)

      data["exercices"].each do |exo|
        @exo = Exercise.new(
          program: @program,
          title: exo["title"],
          content: exo["enonce"]
        )
        @exo.save
      end
      redirect_to program_path(@program), notice: "Program was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def program_params
    params.require(:program).permit(:title, :difficulty, :language, :completion_percentage, :time_constraint)
  end

end
