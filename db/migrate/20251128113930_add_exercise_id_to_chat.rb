class AddExerciseIdToChat < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :exercise, null: true, foreign_key: true
  end
end
