class ChatsController < ApplicationController


  def index
    @chats = Chat.all
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end


  def create
    @chat = Chat.new(title: "New chat")
    @chat.user = current_user

    if @chat.save
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
      messages_attributes: [:content]
    )
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
