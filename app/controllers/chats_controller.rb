class ChatsController < ApplicationController


  def index
    @chats = Chat.all
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end


  def create
    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.context = nil
    @chat.user = current_user
    if params[:exercise_id].present?
      @exercise = Exercise.find(params[:exercise_id])
      @chat.exercise = @exercise
      @chat.context = "exo"
    else
      @chat.context = "prog"
    end

    if @chat.save
      if @chat.context == "exo"
        redirect_to program_exercise_path(@chat.exercise.program, @chat.exercise)
      else
        redirect_to chat_path(@chat)
      end
    else
      render root_path, status: :unprocessable_entity
    end
  end

 def destroy
  @chat = current_user.chats.find(params[:id])
  @chat.destroy

  new_chat = current_user.chats.create(title: "Nouveau chat")

  redirect_to chat_path(new_chat), notice: "Chat supprimé et un nouveau chat a été créé."
  end

  private

  def chat_params
    params.require(:chat).permit(
      :name,
      messages_attributes: [:content]
    )
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
