class ChatsController < ApplicationController

  SYSTEM_PROMPT = ""

  def index
    @chats = Chat.all
  end

  def show
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new
  end

  def new
    @chat = Chat.new
  end

  def create

    @chat = current_user.chats.find(params[:chat_id])
    @program = @chat.program

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_messages_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def destroy
    @chat = current_user.chat.find(params[:id])
    @chat.destroy
    redirect_to chats_path, notice: "Chat supprimé."
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
