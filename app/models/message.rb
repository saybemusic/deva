class Message < ApplicationRecord
  belongs_to :chat


  validates :content, format: { with: /\p{Letter}/, message: "doit contenir au moins une lettre" }

end
