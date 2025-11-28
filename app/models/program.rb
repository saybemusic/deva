class Program < ApplicationRecord
  has_many :exercises, dependent: :destroy

  belongs_to :chat
  belongs_to :user

   def update_completion_percentage!
    total = exercises.count
    finished = exercises.where(finished: true).count

    percentage = total.zero? ? 0 : ((finished.to_f / total) * 100).round
    update_column(:completion_percentage, percentage)
  end
end
