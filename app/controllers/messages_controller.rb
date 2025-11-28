class MessagesController < ApplicationController

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
      if @chat.context == "prog"
        handle_program_context
        redirect_to chat_path(@chat)
      elsif @chat.context == "exo"
        handle_exercise_context
        redirect_to program_exercise_path(@chat.exercise.program, @chat.exercise)
      end
    else
      if @chat.context == "exo"
        render "exercises/show", status: :unprocessable_entity
      else
        render "chats/show", status: :unprocessable_entity
      end
    end
  end

  def update
    @chat = current_user.chats.find(params[:id])
    @message = Message.find(params[:id])
    if @message.update(message_params)
      redirect_to chat_path(@chat), notice: "Message mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def handle_program_context
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history

    if @chat.messages.count == 1
      Message.create(role: "assistant", content: "Quel est ton niveau dans ce domaine?", chat: @chat)
    elsif @chat.messages.count == 3
      Message.create(role: "assistant", content: "Combien de temps tu veux réviser?", chat: @chat)
    elsif @chat.messages.count == 5
      user_messages = @chat.messages.where(role: "user").order(:created_at).limit(3)
      @langage = user_messages[0]&.content
      @niveau = user_messages[1]&.content
      @durée = user_messages[2]&.content

      system_prompt = "Tu es un professeur en langage de programmation.
      Je voudrais apprendre ce langage de programmation (développement) : #{@langage},
      fais moi le nombre d'exos (sans me donner la réponse) qu'il me faut pour cette durée: #{@durée}.
      N'oublie pas mon niveau : #{@niveau}.
      Ta réponse doit être sous un format markdown uniquement et fais des sauts de ligne entre chaque exo."

      response = @ruby_llm_chat.with_instructions(system_prompt).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      @chat.generate_title
    end
  end

  def handle_exercise_context
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history

    exercise_prompt = "Tu es un correcteur d'exercices de programmation.

    Exercice : #{@chat.exercise.title}
    Énoncé : #{@chat.exercise.content}

    L'utilisateur va te soumettre sa réponse ou son code. Tu dois :
    1. Analyser sa réponse
    2. Dire si elle est correcte ou incorrecte
    3. Si elle est incorrecte, expliquer pourquoi en donnant la solution
    4. Si elle est correcte, le féliciter et lui expliquer brièvement pourquoi sa solution fonctionne

    Sois concis et pédagogique. Ne donne JAMAIS la solution complète si la réponse est fausse."

    response = @ruby_llm_chat.with_instructions(exercise_prompt).ask(@message.content)
    Message.create(role: "assistant", content: response.content, chat: @chat)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
