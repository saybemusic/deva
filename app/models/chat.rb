class Chat < ApplicationRecord
  DEFAULT_TITLE = "Nouvelle révision"
  TITLE_PROMPT = "Génère un titre court de quelques mots, maximum 10 mots, qui résume le contenu des exercices par rapport au #{@langage} et à la #{@durée}, mais ne parle pas de niveau"

  has_many :messages, dependent: :destroy
  has_one :program, dependent: :destroy

  belongs_to :user
  belongs_to :exercise, optional: true

  def generate_title
    return unless title == DEFAULT_TITLE
    user_message = messages.where(role: "user").order(:created_at).first
    return if user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(user_message.content)
    update(title: response.content)
  end
end
