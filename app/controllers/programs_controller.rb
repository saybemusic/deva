class ProgramsController < ApplicationController
#  SYSTEM_PROMPT = " Tu est de professeur en langage de programmation
#   Je voudrais apprendre ce langage : #{@langage}, fais moi le nombre d'exo (sans me donner la réponse) qu'il me faut pour cette durée: #{@durée}. n'oublie pas mon niveau : #{@niveau}
#   Ta réponse doit être sous un format markdown uniquement et fais des saut de ligne entre chaque exos

#   exemple :
#   Exo 1 :
#   Exo 2 :"

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
      redirect_to @program, notice: "Le programme a été modifié."
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
    ruby_llm = RubyLLM.chat

    user_messages = @chat.messages.where(role: "user").order(:created_at).limit(3)
    langage = user_messages[0]&.content
    niveau = user_messages[1]&.content
    duree = user_messages[2]&.content

    niveau_prompt = "
      L'utilisateur a répondu son niveau
      Interprète cette réponse et renvoie toujours : Débutant, Intermédiaire ou Avancé."

    standardized_level = ruby_llm.with_instructions(niveau_prompt).ask(niveau).content
    
    @program = Program.new(
      title: @chat.title,
      language: langage,
      difficulty: standardized_level,
      time_constraint: duree,
      chat: @chat,
      user: current_user
    )

    if @program.save
      redirect_to program_path(@program), notice: "Le programme a été créé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def program_params
    params.require(:program).permit(:title, :difficulty, :language, :completion_percentage, :time_constraint)
  end

end
