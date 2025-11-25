class MessagesController < ApplicationController


  SYSTEM_PROMPT = "Fais moi un exo avec toute les données que je t'ai envoyé
  Repond moi dans un format comme exemple : Exo 1 : Fais une fonction fléché"

  def index
    @messages = Message.all
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @chat = current_user.chats.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      if @chat.messages.count == 1
      Message.create(role: "assistant", content: "Quel est ton niveau dans ce domaine?", chat: @chat)
      elsif @chat.messages.count == 3
        Message.create(role: "assistant", content: "Combien de temps tu veux réviser?", chat: @chat)
      elsif @chat.messages.count == 5
        ruby_llm_chat = RubyLLM.chat
        response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
        Message.create(role: "assistant", content: response.content, chat: @chat)
      end
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def update

    @chat = current_user.chat.find(params[:id])
    @message = Message.find(params[:id])
    if @message.update(message_params)
      redirect_to chat_path(@chat), notice: "Message mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
