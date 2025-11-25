class CreateExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :exercises do |t|
      t.string :title
      t.boolean :finished
      t.text :content
      t.string :estimated_time
      t.references :program, null: false, foreign_key: true

      t.timestamps
    end
  end
end
