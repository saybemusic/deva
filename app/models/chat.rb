class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_one :program, dependent: :destroy

  belongs_to :user
end
