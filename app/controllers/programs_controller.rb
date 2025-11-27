class ProgramsController < ApplicationController

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

    @program = Program.new(
      title: @chat.title,
      difficulty: user_messages[1]&.content,
      language: user_messages[0]&.content,
      chat: @chat,
      user: current_user
      )

      if @program.save
        redirect_to program_path(@program), notice: "Nouveau programme crée."
      else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def program_params
    params.require(:program).permit(:title, :difficulty, :language, :completion_percentage, :time_constraint)
  end

end
