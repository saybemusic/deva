class Exercise < ApplicationRecord
  belongs_to :program
  has_many :chats, dependent: :destroy
end
