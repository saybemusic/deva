class Program < ApplicationRecord
  has_many :exercises, dependent: :destroy
  has_one :chat, dependent: :destroy

  belongs_to :chat
  belongs_to :user
end
