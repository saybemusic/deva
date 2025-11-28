class Exercise < ApplicationRecord
  belongs_to :program
  has_many :chats, dependent: :destroy

  after_save :update_program_progress
  after_destroy :update_program_progress

   private

  def update_program_progress
    program.update_completion_percentage!
  end
end
