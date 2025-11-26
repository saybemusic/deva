class ChatsController < ApplicationController


  def index
    @chats = Chat.all
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end


  def create
    @chat = Chat.new(title: "Nouvelle révision")
    @chat.user = current_user

    if @chat.save
      # ruby_llm_chat = RubyLLM.chat
      # response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      # Message.create(role: "assistant", content: response.content, chat: @chat)
      redirect_to chat_path(@chat)
    else
      render root_path, status: :unprocessable_entity
    end
  end

  def destroy
    @chat = current_user.chat.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat supprimé."
  end

  private

  def chat_params
    params.require(:chat).permit(
      :name,
      messages_attributes: [:content]  # <<< autorise le premier message
    )
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
