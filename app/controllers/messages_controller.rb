class MessagesController < ApplicationController


  SYSTEM_PROMPT = " Tu est de professeur en langage de programmation
  Je voudrais apprendre ce langage : #{@langage}, fais moi le nombre d'exo qu'il me faut pour cette durée: #{@durée}. n'oublie pas mon niveau : #{@niveau}
  Ta réponse doit être sous un format markdown uniquement et fais des saut de ligne entre chaque exos

  exemple :
  Exo 1 :
  Exo 2 :"

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
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      if @chat.messages.count == 1
      Message.create(role: "assistant", content: "Quel est ton niveau dans ce domaine?", chat: @chat)
      elsif @chat.messages.count == 3
        Message.create(role: "assistant", content: "Combien de temps tu veux réviser?", chat: @chat)
      elsif @chat.messages.count == 5
        response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
        Message.create(role: "assistant", content: response.content, chat: @chat)
      end
      # @langage = @chat.message.where(:role "user").first.content
      user_messages = @chat.messages.where(role: "user").order(:created_at).limit(3)
      @langage = user_messages[0]&.content
      @niveau = user_messages[1]&.content
      @durée = user_messages[2]&.content
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

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
